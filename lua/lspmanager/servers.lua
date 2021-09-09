local servers = {
	["angularls"] = require("lspmanager.servers.angularls"),
    ["clangd"] = require("lspmanager.servers.clangd"),
	["omnisharp"] = require("lspmanager.servers.omnisharp"),
    ["rust_analyzer"] = require("lspmanager.servers.rust_analyzer"),
	["sumneko_lua"] = require("lspmanager.servers.sumneko_lua"),
    ["svelte_lsp"] = require("lspmanager.servers.svelte_lsp"),
    ["tailwindcss"] = require("lspmanager.servers.tailwindcss_lsp"),
    ["vue_lsp"] = require("lspmanager.servers.vue_lsp")
}

return servers
