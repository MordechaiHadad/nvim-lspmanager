local servers = {
	["angularls"] = require("lspmanager.servers.angularls"),
	["omnisharp"] = require("lspmanager.servers.omnisharp"),
	["sumneko_lua"] = require("lspmanager.servers.sumneko_lua"),
    ["rust_analyzer"] = require("lspmanager.servers.rust_analyzer")
}

return servers
