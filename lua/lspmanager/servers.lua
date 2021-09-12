local servers = {
	["angularls"] = require("lspmanager.servers.angularls"),
    ["clangd"] = require("lspmanager.servers.clangd"),
    ["cssls"] = require("lspmanager.servers.cssls"),
    ["fsautocomplete"] = require("lspmanager.servers.fsautocomplete"),
    ["html"] = require("lspmanager.servers.html"),
    ["jsonls"] = require("lspmanager.servers.jsonls"),
	["omnisharp"] = require("lspmanager.servers.omnisharp"),
    ["pyright"] = require("lspmanager.servers.pyright"),
    ["rust_analyzer"] = require("lspmanager.servers.rust_analyzer"),
	["sumneko_lua"] = require("lspmanager.servers.sumneko_lua"),
    ["sveltels"] = require("lspmanager.servers.sveltels"),
    ["tailwindcssls"] = require("lspmanager.servers.tailwindcssls"),
    ["tsserver"] = require("lspmanager.servers.tsserver"),
    ["vuels"] = require("lspmanager.servers.vuels")
}

return servers
