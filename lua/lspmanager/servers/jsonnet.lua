local lsp_name = "jsonnet"
local config = require("lspmanager.utilities").get_config(lsp_name).document_config.default_config
local installers = require("lspmanager.installers")
local os = require("lspmanager.os")

local pkgs = { "github.com/grafana/jsonnet-language-server" }

local cmd_exec = "./jsonnet-language-server"

if os.get_os() == os.OSes.Windows then
    cmd_exec = cmd_exec .. ".exe"
end

config.cmd[1] = cmd_exec

return {
    config = config,

    install_script = function()
        return installers.go.install_script(pkgs)
    end,

    update_script = function()
        return installers.go.update_script(pkgs)
    end,
}
