local lsp_name = "gopls"
local config = require("lspmanager.utilities").get_config(lsp_name)
local installers = require("lspmanager.installers")
local os = require("lspmanager.os")

local pkgs = { "golang.org/x/tools/gopls" }

local cmd_exec = "./gopls"

if os.get_os() == os.OSes.Windows then
    cmd_exec = cmd_exec .. ".exe"
end

config.default_config.cmd[1] = cmd_exec

return {
    config = config,

    install_script = function()
        return installers.go.install_script(pkgs)
    end,

    update_script = function()
        return installers.go.update_script(pkgs)
    end,
}
