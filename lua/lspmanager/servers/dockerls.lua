local lsp_name = "dockerls"
local config = require("lspmanager.utilities").get_config(lsp_name)
local installers = require("lspmanager.installers")

config.default_config.cmd[1] = "./node_modules/.bin/docker-langserver"

return vim.tbl_extend("error", config, {
    install_script = function()
        return installers.npm.install_script({"dockerfile-language-server-nodejs"})
    end,

    update_script = function()
        return installers.npm.update_script()
    end,
})
