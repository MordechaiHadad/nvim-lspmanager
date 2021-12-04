local servers = {
    "angularls",
    "bashls",
    "clangd",
    "clojure_lsp",
    "cmake",
    "cssls",
    "dockerls",
    "elixirls",
    "elmls",
    "emmet_ls",
    "fsautocomplete",
    "hls",
    "html",
    "jsonls",
    "kotlin_language_server",
    "omnisharp",
    "purescriptls",
    "pyright",
    "rust_analyzer",
    "solang",
    "sumneko_lua",
    "svelte",
    "tailwindcss",
    "terraformls",
    "texlab",
    "tsserver",
    "vimls",
    "volar",
    "vuels",
}

return {
    get = function(server_name)
        if server_name then
            return require("lspmanager.servers." .. server_name)
        end
        return servers
    end,

    set = function(user_configs)
        vim.validate({ user_configs = { user_configs, "table" } })

        local new_servers = {}
        for name, configuration in pairs(user_configs) do
            local server = require("lspmanager.servers." .. name)
            server = vim.tbl_deep_extend("force", server, {
                config = {
                    cmd = configuration.cmd or server.config.cmd,
                    document_config = { default_config = configuration }
                },
            })
            new_servers[name] = server
        end
        return new_servers
    end,
}
