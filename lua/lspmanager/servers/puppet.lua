local lsp_name = "puppet"
local config = require("lspmanager.utilities").get_config(lsp_name)
local os = require("lspmanager.os")

local cmd_exec = "./puppet-languageserver"

if os.get_os() == os.OSes.Windows then
    cmd_exec = cmd_exec .. ".cmd"
end

config.default_config.cmd = {"ruby", "puppet-languageserver", "--stdio"}

local function install_script()
    if os.get_os() == os.OSes.Windows then
        return [[
        ]]
    end

    return [[
    if ! command -v jq &> /dev/null
    then
        exit 123
    fi

    version=$(curl -s "https://api.github.com/repos/puppetlabs/puppet-editor-services/releases/latest" | jq -r '.tag_name')

    curl -L -o "puppet.zip" "https://github.com/puppetlabs/puppet-editor-services/releases/download/$version/puppet_editor_services_$version.zip"
    unzip puppet.zip
    rm puppet.zip

    echo $version > VERSION
    ]]
end

return {
    config = config,

    install_script = install_script,
}
