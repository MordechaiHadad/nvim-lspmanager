local jobs = {}

local servers = require("lspmanager.servers")
local os = require("lspmanager.os")

function jobs.installation_job(lsp, path, is_update)
    local shell = ""
    if os.get_os() == os.OSes.Windows then
        shell = "powershell.exe"
    else
        shell = "bash"
    end

    vim.fn.jobstart({ shell, "-c", servers[lsp].install_script() }, {
        cwd = path,
        on_exit = function(_, exitcode)
            if is_update then
                if exitcode == 0 then
                    print("Successfully updated " .. lsp)
                elseif exitcode == 123 then
                    print("Jq isn't installed please install it reinstall " .. lsp)

                    vim.fn.delete(path, "rf")
                else
                    print("Failed to update .. " .. lsp)
                end
            else
                if exitcode == 0 then
                    print("Successfully installed " .. lsp)

                    vim.schedule(function()
                        if vim.api.nvim_buf_get_name(0) ~= "" then
                            lspmanager.setup_servers(true, lsp)
                            vim.cmd("bufdo e")
                        end
                    end)
                elseif exitcode == 123 then
                    print("Jq isn't installed, please install jq and reinstall " .. lsp)
                    vim.fn.delete(path, "rf")
                else
                    print("Failed to install " .. lsp)
                    vim.fn.delete(path, "rf")
                end
            end
        end,
    })
end

function jobs.update_job(lsp, path) -- NOTE: might add mass update if viable
    local shell = ""
    if os.get_os() == os.OSes.Windows then
        shell = "powershell.exe"
    else
        shell = "bash"
    end

    vim.fn.jobstart({ shell, "-c", servers[lsp].update_script() }, {
        cwd = path,
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
end

return jobs
