local lsp_name = "cssls"
local config = require("lspmanager.utilities").get_config(lsp_name)

config.default_config.cmd[1] = "./node_modules/.bin/vscode-css-language-server"

return vim.tbl_extend("error", config, {
	install_script = function()
		return require("lspmanager.installers.npm").install_script("vscode-langservers-extracted")
	end,

    update_script = function ()
        return require("lspmanager.installers.npm").update_script()
    end
})
