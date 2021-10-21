local lsp_name = "elmls"
local config = require("lspmanager.utilities").get_config(lsp_name)
local installers = require("lspmanager.installers")
local os = require("lspmanager.os")

local cmd_exec = "./node_modules/.bin/elm-language-server"

if os.get_os() == os.OSes.Windows then
    cmd_exec = cmd_exec .. ".cmd"
end

config.default_config.cmd[1] = cmd_exec

return {
    config = config,

    install_script = function()
        return installers.npm.install_script({ "elm", "elm-test", "elm-format", "@elm-tooling/elm-language-server" })
    end,

    update_script = function()
        return installers.npm.update_script()
    end,
}
