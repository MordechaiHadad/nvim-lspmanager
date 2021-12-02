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
    "kotlinls",
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

        for name, configuration in pairs(user_configs) do
            servers[name] = vim.tbl_deep_extend("force", servers[name], {
                config = {
                    default_config = configuration,
                },
            })
        end

        return servers
    end,
}
