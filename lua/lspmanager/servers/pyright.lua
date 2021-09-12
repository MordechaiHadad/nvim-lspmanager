local lsp_name = "pyright"
local config = require("lspmanager.utilities").get_config(lsp_name)

config.default_config.cmd[1] = "./node_modules/.bin/pyright-langserver"

return vim.tbl_extend("error", config, {
    install_script = function()
        return require("lspmanager.installers.npm").install_script("pyright")
    end,

    update_script = function()
        return require("lspmanager.installers.npm").update_script()
    end,
})
