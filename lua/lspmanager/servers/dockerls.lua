local lsp_name = "dockerls"
local config = require("lspmanager.utilities").get_config(lsp_name).document_config.default_config
local installers = require("lspmanager.installers")
local os = require("lspmanager.os")

local cmd_exec = "./node_modules/.bin/docker-langserver"

if os.get_os() == os.OSes.Windows then
    cmd_exec = cmd_exec .. ".cmd"
end

config.cmd[1] = cmd_exec

return {
    config = config,

    install_script = function()
        return installers.npm.install_script({ "dockerfile-language-server-nodejs" })
    end,

    update_script = function()
        return installers.npm.update_script()
    end,
}
