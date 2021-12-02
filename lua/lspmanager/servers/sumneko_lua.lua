local lsp_name = "sumneko_lua"
local config = require("lspmanager.utilities").get_config(lsp_name)
local os = require("lspmanager.os")

local cmd_exec = "./extension/server/bin/"

local current_os = os.get_os()
if current_os == os.OSes.Windows then
    cmd_exec = cmd_exec .. "Windows/lua-language-server.exe"
elseif current_os == os.OSes.MacOS then
    cmd_exec = cmd_exec .. "macOS/lua-language-server"
else
    cmd_exec = cmd_exec .. "Linux/lua-language-server"
end

config.cmd = { cmd_exec, "-E", "./extension/server/main.lua" }

local function install_script()
    if os.get_os() == os.OSes.Windows then
        return [[
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        function get_latest_version() {
            $response = invoke-restmethod -uri "https://api.github.com/repos/sumneko/vscode-lua/releases/latest"
            return $response.tag_name
        }
        $version = get_latest_version
        $otherversion = $version.Trim("v")

        $url = "https://github.com/sumneko/vscode-lua/releases/download/$($version)/lua-$($otherversion).vsix"
        $out = "lua.vsix"

        if (Test-Path -Path Get-Location) {
            Remove-Item Get-Location -Force -Recurse
        }

        Invoke-WebRequest -Uri $url -OutFile $out

        Invoke-Expression 'tar -xf $($out)'
        Out-File -FilePath VERSION -Encoding string -InputObject "$($version)"
        Remove-Item $out
        ]]
    end
    return [[
    if ! command -v jq &> /dev/null
        then
            exit 123
            fi

            os=$(uname -s | tr "[:upper:]" "[:lower:]")
            version=$(curl -s "https://api.github.com/repos/sumneko/vscode-lua/releases/latest" | jq -r '.tag_name')

            case $os in
            linux)
            platform="Linux"
            ;;
            darwin)
            platform="macOS"
            ;;
            esac


            curl -L -o "sumneko-lua.vsix" "https://github.com/sumneko/vscode-lua/releases/download/$version/lua-$(echo $version | sed 's/v//').vsix"
            rm -rf sumneko-lua
            unzip sumneko-lua.vsix -d .
            rm sumneko-lua.vsix

            chmod +x extension/server/bin/$platform/lua-language-server

            echo $version > VERSION
            ]]
end

return {
    config = config,

    install_script = install_script,

    update_script = function()
        return require("lspmanager.installers.manual").update_script("sumneko/vscode-lua")
    end,
}
