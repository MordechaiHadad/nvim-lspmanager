local lspmanager = {}

local job = require("plenary.job")
local servers = require("lspmanager/servers")
local configs = require("lspconfig/configs")

function lspmanager.setup()
    vim.cmd([[
    command! -nargs=1 -complete=customlist,v:lua.available_servers LspInstall lua require('lspmanager').install('<args>')
    command! -nargs=1 -complete=customlist,v:lua.installed_servers LspUninstall lua require('lspmanager').uninstall('<args>')
    command! -nargs=1 -complete=customlist,v:lua.installed_servers LspUpdate lua require('lspmanager').update('<args>')
    ]])
    for lang, server_config in pairs(servers) do
        if is_lsp_installed(lang) == 1 and not configs[lang] then
            local config = vim.tbl_deep_extend("keep", server_config, { default_config = { cmd_cwd = get_path(lang) } })
            if config.default_config.cmd then
                local executable = config.default_config.cmd[1]
                config.default_config.cmd[1] = get_path(lang) .. "/" .. executable
            end
            configs[lang] = config
        end
    end
    setup_servers()
end

function get_path(lang)
    return vim.fn.stdpath("data") .. "/lspmanager/" .. lang
end

function is_lsp_installed(lang)
    return vim.fn.isdirectory(get_path(lang))
end

function available_servers()
    return vim.tbl_keys(servers)
end

function installed_servers()
    return vim.tbl_filter(function(key)
        return is_lsp_installed(key) == 1
    end, available_servers())
end

function setup_servers()
    local servers = installed_servers()
    for _, server in pairs(servers) do
        require("lspconfig")[server].setup({})
    end
end

function lspmanager.install(lsp)
    if not servers[lsp] then
        error("could not find LSP " .. lsp)
    end

    local path = get_path(lsp)
    vim.fn.mkdir(path, "p")

    job:new({
        command = "bash",
        cwd = path,
        args = { "-c", servers[lsp].install_script() },
        on_exit = function(j, return_val)
            if return_val == 0 then
                print("sucksexfully installed " .. lsp)
            end
        end,
    }):start()
end

function lspmanager.uninstall(lsp)
    if not servers[lsp] then
        error("could not find LSP " .. lsp)
    end

    if is_lsp_installed(lsp) == 0 then
        error(lsp .. " is not installed")
    end

    local path = get_path(lsp)
    if vim.fn.delete(path, "rf") == 0 then
        vim.notify("sucksexfully uninstalled " .. lsp)
    else
        error("failed to uninstall " .. lsp)
    end
end

function lspmanager.update(lsp)
    if not servers[lsp] then
        error("Could not find LSP " .. lsp)
    end

    if is_lsp_installed(lsp) == 0 then
        error(lsp .. " is not installed")
    end

    local path = get_path(lsp)

    job:new({
        command = "bash",
        cwd = path,
        args = { "-c", servers[lsp].update_script() }, --TODO: change how to fetch update scripts dont wanna pollute every lsp with their own copy paste of require npm update script
        on_exit = function(j, return_val)
            if return_val == 69 then
                print(lsp .. " is up to date")
            elseif return_val == 70 then
                vim.schedule(function ()
                    lspmanager.install(lsp)
                end)

            elseif return_val == 0 then
                print("sucksexfully updated " .. lsp) --TODO: refactor this else if stuff makes me feel like yanderedev coding
            end
        end,
    }):start()
end

return lspmanager
