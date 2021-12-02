local lsp_name = "cmake"
local config = require("lspmanager.utilities").get_config(lsp_name)
local pip = require("lspmanager.installers.pip")
local os = require("lspmanager.os")

local cmd_exec = "./venv/bin/cmake-language-server"

if os.get_os() == os.OSes.Windows then
    cmd_exec = cmd_exec .. ".cmd"
end

config.cmd = {cmd_exec}

local args = { "cmake-language-server" }

return {
    config = config,

    install_script = function()
        return pip.install_script(args)
    end,

    update_script = function()
        return pip.update_script(args)
    end,
}
