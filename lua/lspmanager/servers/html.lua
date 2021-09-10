local lsp_name = "html"
local config = require("lspmanager.utilities").get_config(lsp_name)

config.default_config.cmd[1] = "./node_modules/.bin/vscode-html-language-server"

return vim.tbl_extend("error", config, {
	install_script = function()
		return require("lspmanager.package_managers.npm").install_script("vscode-langservers-extracted")
	end,

    update_script = function ()
        return require("lspmanager.package_managers.npm").update_script()
    end
})
