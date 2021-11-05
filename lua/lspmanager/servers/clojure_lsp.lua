local lsp_name = "clojure_lsp"
local config = require("lspmanager.utilities").get_config(lsp_name)
local os = require("lspmanager.os")

local cmd_exec = "./clojure-lsp"

local current_os = os.get_os()
if current_os == os.OSes.Windows then
    cmd_exec = cmd_exec .. ".exe"
end

config.default_config.cmd[1] = cmd_exec

local function install_script()
    if os.get_os() == os.OSes.Windows then
        return [[
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        function get_latest_version() {
            $response = invoke-restmethod -uri "https://api.github.com/repos/clojure-lsp/clojure-lsp/releases/latest"
            return $response.tag_name
        }
        $version = get_latest_version

        $url = "https://github.com/clojure-lsp/clojure-lsp/releases/download/$($version)/clojure-lsp-native-windows-amd64.zip" 
        $out = "clojure_lsp.zip"

        if (Test-Path -Path Get-Location) {
            Remove-Item Get-Location -Force -Recurse
        }

        Invoke-WebRequest -Uri $url -OutFile $out

        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($out, ".")

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
    version=$(curl -s "https://api.github.com/repos/clojure-lsp/clojure-lsp/releases/latest" | jq -r '.tag_name')

    case $os in
    linux)
    platform="linux"
    ;;
    darwin)
    platform="macos"
    ;;
    esac


    curl -L -o "clojure_lsp.zip" "https://github.com/clojure-lsp/clojure-lsp/releases/download/$version/clojure-lsp-native-$platform-amd64.zip"
    unzip clojure_lsp.zip -d .
    rm clojure_lsp.zip

    chmod +x clojure-lsp

    echo $version > VERSION
    ]]
end

return {
    config = config,

    install_script = install_script,

    update_script = function()
        return require("lspmanager.installers.manual").update_script("clojure-lsp/clojure-lsp")
    end,
}
