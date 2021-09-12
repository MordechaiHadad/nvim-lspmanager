local lspmanager = {}

local servers = require("lspmanager.servers")
local configs = require("lspconfig/configs") -- NOTE: Bruh
local jobs = require("lspmanager.jobs")
local utilities = require("lspmanager.utilities") -- TODO: learn how to declare get_path once and without it saying lsp is a nil value

lspmanager.setup = function ()
    for lang, server_config in pairs(servers) do
        if lspmanager.is_lsp_installed(lang) == 1 and not configs[lang] then
            local config = vim.tbl_deep_extend(
                "keep",
                server_config,
                { default_config = { cmd_cwd = utilities.get_path(lang) } }
            )
            if config.default_config.cmd then
                local executable = config.default_config.cmd[1]
                if vim.regex([[\.\/]]):match_str(executable) then
                    config.default_config.cmd[1] = utilities.get_path(lang) .. "/" .. executable
                end
            end
            configs[lang] = config
        end
    end
    lspmanager.setup_servers()
end

lspmanager.is_lsp_installed = function(lang)
    return vim.fn.isdirectory(utilities.get_path(lang))
end

lspmanager.available_servers = function ()
    return vim.tbl_keys(servers)
end

lspmanager.installed_servers = function ()
    return vim.tbl_filter(function(key)
        return lspmanager.is_lsp_installed(key) == 1
    end, lspmanager.available_servers())
end

lspmanager.setup_servers = function ()
    local installed_servers = lspmanager.installed_servers()
    for _, server in pairs(installed_servers) do
        if utilities.is_vscode_lsp(server) then
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            require("lspconfig")[server].setup({
                capabilities = capabilities,
            })
        else
            require("lspconfig")[server].setup({})
        end
    end

    require("lspconfig").gdscript.setup({})
end

lspmanager.install = function(lsp)
    if not servers[lsp] then
        error("could not find LSP " .. lsp)
    end

    local path = utilities.get_path(lsp)
    vim.fn.mkdir(path, "p")

    jobs.installation_job(lsp, path, false)
end

lspmanager.uninstall = function(lsp)
    if not servers[lsp] then
        error("could not find LSP " .. lsp)
    end

    if lspmanager.is_lsp_installed(lsp) == 0 then
        error(lsp .. " is not installed")
    end

    local path = utilities.get_path(lsp)
    if vim.fn.delete(path, "rf") == 0 then
        vim.notify("Successfully uninstalled " .. lsp)
    else
        error("failed to uninstall " .. lsp)
    end
end

lspmanager.update = function(lsp)
    if not servers[lsp] then
        error("Could not find LSP " .. lsp)
    end

    if lspmanager.is_lsp_installed(lsp) == 0 then
        error(lsp .. " is not installed")
    end

    local path = utilities.get_path(lsp)

    jobs.update_job(lsp, path)
end

lspmanager.test = function(lsp) end

return lspmanager
