local lspmanager = {}

local servers = require("lspmanager.servers")
local configs = require("lspconfig/configs") -- NOTE: Bruh
local jobs = require("lspmanager.jobs")
local utilities = require("lspmanager.utilities") -- TODO: learn how to declare get_path once and without it saying lsp is a nil value

function lspmanager.setup()
    vim.cmd([[
    command! -nargs=1 -complete=customlist,v:lua.available_servers LspInstall lua require('lspmanager').install('<args>')
    command! -nargs=1 -complete=customlist,v:lua.installed_servers LspUninstall lua require('lspmanager').uninstall('<args>')
    command! -nargs=1 -complete=customlist,v:lua.installed_servers LspUpdate lua require('lspmanager').update('<args>')
    command! -nargs=1 -complete=customlist,v:lua.installed_servers LspHi lua require('lspmanager').test('<args>')
    autocmd BufNewFile,BufRead *.fs,*.fsx,*.fsi set filetype=fsharp
    ]])
    for lang, server_config in pairs(servers) do
        if is_lsp_installed(lang) == 1 and not configs[lang] then
            local config = vim.tbl_deep_extend("keep", server_config, { default_config = { cmd_cwd = utilities.get_path(lang) } })
            if config.default_config.cmd then
                local executable = config.default_config.cmd[1]
                if vim.regex([[\.\/]]):match_str(executable) then
                    config.default_config.cmd[1] = utilities.get_path(lang) .. "/" .. executable
                end
            end
            configs[lang] = config
        end
    end
    setup_servers()
end

function is_lsp_installed(lang)
    return vim.fn.isdirectory(utilities.get_path(lang))
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
    local installed_servers = installed_servers()
    for _, server in pairs(installed_servers) do
        if utilities.is_vscode_lsp(server) then

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            require("lspconfig")[server].setup{
                capabilities = capabilities
            }
        else
            require("lspconfig")[server].setup({})
        end
    end
end

function lspmanager.install(lsp)
    if not servers[lsp] then
        error("could not find LSP " .. lsp)
    end

    local path = utilities.get_path(lsp)
    vim.fn.mkdir(path, "p")

    jobs.installation_job(lsp, path, false)
end

function lspmanager.uninstall(lsp)
    if not servers[lsp] then
        error("could not find LSP " .. lsp)
    end

    if is_lsp_installed(lsp) == 0 then
        error(lsp .. " is not installed")
    end

    local path = utilities.get_path(lsp)
    if vim.fn.delete(path, "rf") == 0 then
        vim.notify("Successfully uninstalled " .. lsp)
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

    local path = utilities.get_path(lsp)

    jobs.update_job(lsp, path)
end

function lspmanager.test(lsp)
end

return lspmanager
