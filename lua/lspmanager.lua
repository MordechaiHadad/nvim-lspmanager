local lspmanager = {}

local servers_list = require("lspmanager.servers").get()
local jobs = require("lspmanager.jobs")
local get_path = require("lspmanager.utilities").get_path
local enable_gdscript = false

lspmanager.setup = function(user_configs)
    user_configs = user_configs or {}
    servers = require("lspmanager.servers").set(user_configs.lsps or {})
	require("lspmanager.info.config").setup(user_configs.info or {})
    enable_gdscript = user_configs.enable_gdscript or false

    lspmanager.setup_servers(nil)
    lspmanager.ensure_installed(user_configs.ensure_installed or {})
end

lspmanager.is_lsp_installed = function(lsp)
    return vim.fn.isdirectory(get_path(lsp))
end

lspmanager.available_servers = function()
    return vim.tbl_values(servers_list)
end

lspmanager.suggested_servers = function(filetype)
    local available = lspmanager.available_servers()
    local available_for_filetype = {}
    for _, lsp_name in pairs(servers_list) do
        local config = require("lspmanager.utilities").get_config(lsp_name)
        if vim.tbl_contains(available, lsp_name) then
            if vim.tbl_contains(config.document_config.default_config.filetypes, filetype) then
                table.insert(available_for_filetype, lsp_name)
            end
        end
    end
    return available_for_filetype
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

lspmanager.setup_servers = function(lsp)
    if lsp == nil then
        for _, lsp_name in pairs(lspmanager.installed_servers()) do
            lspmanager.setup_servers(lsp_name)
        end
        if enable_gdscript then
            require("lspconfig").gdscript.setup({})
        end
    else
        local server = servers[lsp] or require("lspmanager.servers").get(lsp)
        local config = server.config
        local path = get_path(lsp)
        if config.cmd then
            local executable = config.cmd[1]
            if vim.regex([[\.\/]]):match_str(executable) then
                config.cmd[1] = path .. "/" .. executable
            end

            if lsp == "sumneko_lua" then
                local main = config.cmd[3]
                config.cmd[3] = path .. "/" .. main
            end
        end

        if require("lspmanager.utilities").is_vscode_lsp(lsp) then
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            config.capabilities = capabilities

            require("lspconfig")[lsp].setup(config)
        else
            require("lspconfig")[lsp].setup(config)
        end
    end
end

lspmanager.install = function(lsp)
    if not lsp or lsp == "" then
        local filetype = vim.bo.filetype

        if vim.api.nvim_buf_get_name(0) == "" or filetype == "" then
            error("No file attached in current buffer, aborting...")
        end

        local available_for_filetype = require("lspmanager").suggested_servers(vim.bo.filetype)
        if #available_for_filetype == 1 then
            for _, config in pairs(vim.lsp.get_active_clients()) do
                if config.name == available_for_filetype[1] then
                    print("Lsp for " .. filetype .. " is already installed and running")
                    return
                end
            end

            local path = get_path(available_for_filetype[1])
            vim.fn.mkdir(path, "p")

            print("Installing " .. available_for_filetype[1] .. " for current file type...")
            jobs.installation_job(available_for_filetype[1], path, false)
        elseif #available_for_filetype == 0 then
            error("no server found for filetype " .. filetype)
        elseif #available_for_filetype > 1 then
            print(
                "multiple servers found ("
                    .. table.concat(available_for_filetype, "/")
                    .. "), please install one of them"
            )
        end

        return
    end

    if not vim.tbl_contains(servers_list, lsp) then
        error("could not find LSP " .. lsp)
    end

    for _, config in pairs(vim.lsp.get_active_clients()) do
        if config.name == lsp then
            print("Lsp for " .. lsp .. " is already installed and running")
            return
        end
    end

    local path = get_path(lsp)
    vim.fn.mkdir(path, "p")

    print("Installing " .. lsp .. "...")
    jobs.installation_job(lsp, path, false)
end

lspmanager.uninstall = function(lsp)
    if not vim.tbl_contains(servers_list, lsp) then
        error("could not find LSP " .. lsp)
    end

    if lspmanager.is_lsp_installed(lsp) == 0 then
        error(lsp .. " is not installed")
    end

    local path = get_path(lsp)
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

    if not vim.tbl_contains(servers_list, lsp) then
        error("Could not find LSP " .. lsp)
    end

    if lspmanager.is_lsp_installed(lsp) == 0 then
        error(lsp .. " is not installed")
    end

    local path = get_path(lsp)

    print("Looking for " .. lsp .. " updates...")

    jobs.update_job(lsp, path)
end

lspmanager.ensure_installed = function(ensure_installed)
    if #ensure_installed > 0 then
        for _, server in ipairs(ensure_installed) do

            if not servers_list[server] then
                goto skip
            end

            for _, config in pairs(vim.lsp.get_active_clients()) do
                if config.name == server then
                    goto skip
                end
            end

            if lspmanager.is_lsp_installed(server) == 1 then
                goto skip
            end

            local path = get_path(server)
            vim.fn.mkdir(path, "p")

            print("Installing " .. server .. "...")
            jobs.installation_job(server, path, false)

            ::skip::
        end
    end
end

return lspmanager
