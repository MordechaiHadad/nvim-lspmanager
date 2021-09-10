local lsp_name = "vuels"
local config = require("lspmanager.utilities").get_config(lsp_name)

config.default_config.cmd[1] = "./node_modules/.bin/vls"

return vim.tbl_extend("error", config, {
	install_script = function()
		return require("lspmanager.package_managers.npm").install_script("vls")
	end,

    update_script = function ()
        return require("lspmanager.package_managers.npm").update_script()
    end
})
