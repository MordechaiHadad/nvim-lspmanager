local lsp_name = "kotlin_language_server"
local config = require("lspmanager.utilities").get_config(lsp_name)
local installers = require("lspmanager.installers")
local os = require("lspmanager.os")

local cmd_exec = "./server/bin/kotlin-language-server"

if os.get_os == os.OSes.Windows then
    cmd_exec = cmd_exec .. ".bat"
end

config.cmd[1] = cmd_exec

local function install_script()
    if os.get_os() == os.OSes.Windows then
        return [[
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        function get_latest_version() {
            $response = Invoke-RestMethod -Uri "https://api.github.com/repos/fwcd/kotlin-language-server/releases/latest"
            return $response.tag_name
        }

        $version = get_latest_version
        $url = "https://github.com/fwcd/kotlin-language-server/releases/download/$($version)/server.zip"
        $out = "server.zip"
        
        if (Test-Path -Path Get-Location) {
            Remove-Item Get-Location -Force -Recurse
        }
        
        Invoke-WebRequest -Uri $url -OutFile $out
        
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($out, "server")
        
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
    version=$(curl -s "https://api.github.com/repos/fwcd/kotlin-language-server/releases/latest" | jq -r '.tag_name')

    case $os in
    linux)
    platform="linux"
    ;;
    darwin)
    platform="mac"
    ;;
    esac

    curl -L -o "server.zip" "https://github.com/fwcd/kotlin-language-server/releases/download/$version/server.zip"
    unzip server.zip

    rm server.zip

    echo $version > VERSION
    ]]
end

return {
    config = config,

    install_script = install_script,

    update_script = function()
        return installers.manual.update_script("fwcd/kotlin-language-server")
    end,
}
