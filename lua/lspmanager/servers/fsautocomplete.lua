local lsp_name = "fsautocomplete"
local config = require("lspmanager.utilities").get_config(lsp_name)
local installer = require("lspmanager.installers.dotnet")

config.default_config.cmd[2] = "fsautocomplete"

return {
    config = config,

    install_script = function()
        return installer.install_script(lsp_name)
    end,

    update_script = function()
        return installer.update_script(lsp_name)
    end,
}
