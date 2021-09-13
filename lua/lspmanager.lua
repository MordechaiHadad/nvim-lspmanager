lspmanager = {}

local servers = require("lspmanager.servers")
local configs = require("lspconfig/configs")
local jobs = require("lspmanager.jobs")
local utilities = require("lspmanager.utilities") -- TODO: learn how to declare get_path once and without it saying lsp is a nil value

lspmanager.setup = function()
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

lspmanager.available_servers = function()
    return vim.tbl_keys(servers)
end

lspmanager.installed_servers = function(opts)
    opts = opts or {}
    local res = {}
    if opts.insert_key_all then
        table.insert(res, "all")
    end
    local installed = vim.tbl_filter(function(key)
        return lspmanager.is_lsp_installed(key) == 1
    end, lspmanager.available_servers())
    vim.list_extend(res, installed)
    return res
end

lspmanager.setup_servers = function()
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
    if not lsp or lsp == "" then
        local filetype = vim.bo.filetype

        if vim.lsp.buf.server_ready() then
            error("Server for filetype " .. filetype .. " already working")
        end
        if vim.api.nvim_buf_get_name(0) == "" or filetype == "" then
            error("No file attached in current buffer, aborting...")
        end

        local available = lspmanager.available_servers()
        local available_for_filetype = {}
        for lang, config in pairs(servers) do
            if vim.tbl_contains(available, lang) then
                if vim.tbl_contains(config.default_config.filetypes, filetype) then
                    table.insert(available_for_filetype, lang)
                end
            end
        end

        if #available_for_filetype == 1 then
            print("installing " .. available_for_filetype[1] .. " for current file type...")
            lspmanager.install(available_for_filetype[1])
        elseif #available_for_filetype == 0 then
            error("no server found for filetype " .. filetype)
        elseif #available_for_filetype > 1 then
            error(
                "multiple servers found ("
                    .. table.concat(available_for_filetype, "/")
                    .. "), please install one of them"
            )
        end

        return
    end

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
    if lsp == "all" then
        local installed = lspmanager.installed_servers()
        for _, server in pairs(installed) do
            lspmanager.update(server)
        end
        return
    end

    if not servers[lsp] then
        error("Could not find LSP " .. lsp)
    end

    if lspmanager.is_lsp_installed(lsp) == 0 then
        error(lsp .. " is not installed")
    end

    local path = utilities.get_path(lsp)

    jobs.update_job(lsp, path)
end

return lspmanager
