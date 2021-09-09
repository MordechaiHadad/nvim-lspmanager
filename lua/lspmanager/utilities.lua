local utilities = {}

function utilities.get_config(name)
	-- needed so we can restore the initial state at the end
	local was_config_set = require("lspconfig/configs")[name]
	local was_package_loaded = package.loaded["lspconfig/" .. name]

	-- gets or requires config
	local config = require("lspconfig")[name].document_config

	-- restore the initial state
	if not was_config_set then
		require("lspconfig/configs")[name] = nil
	end
	if not was_package_loaded then
		package.loaded["lspconfig/" .. name] = nil
	end

	return vim.deepcopy(config)
end

return utilities
