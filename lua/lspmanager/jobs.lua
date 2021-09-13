local jobs = {}

local job = require("plenary.job")
local servers = require("lspmanager.servers")

function jobs.installation_job(lsp, path, is_update)
    job
        :new({
            command = "bash",
            cwd = path,
            args = { "-c", servers[lsp].install_script() },
            on_exit = function(_, exitcode)
                if is_update then
                    if exitcode == 0 then
                        print("Successfully updated " .. lsp)
                    else
                        print("Failed to update .. " .. lsp)
                    end
                else
                    if exitcode == 0 then
                        print("Successfully installed " .. lsp)

                        vim.schedule(function()
                            lspmanager.setup_servers()

                            if vim.api.nvim_buf_get_name(0) ~= "" then
                                vim.cmd("bufdo e")
                            end
                        end)
                    else
                        print("Failed to install " .. lsp)
                    end
                end
            end,
        })
        :start()
end

function jobs.update_job(lsp, path) -- NOTE: might add mass update if viable
    job
        :new({
            command = "bash",
            cwd = path,
            args = { "-c", servers[lsp].update_script() }, --TODO: change how to fetch update scripts dont wanna pollute every lsp with their own copy paste of require npm update script
            on_exit = function(_, exitcode)
                if exitcode == 69 then
                    print(lsp .. " is up to date")
                elseif exitcode == 70 then -- NOTE: this is just for manual for now i think might refactor this soon
                    jobs.installation_job(lsp, path, true)
                elseif exitcode == 0 then
                    print("Successfully updated " .. lsp) --TODO: refactor this else if stuff makes me feel like yanderedev coding
                end
            end,
        })
        :start()
end

return jobs
