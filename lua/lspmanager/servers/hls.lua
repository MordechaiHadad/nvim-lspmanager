local lsp_name = "hls"
local config = require("lspmanager.utilities").get_config(lsp_name)
local installers = require("lspmanager.installers")
local os = require("lspmanager.os")

local cmd_exec = "./hls"

if os.get_os == os.OSes.Windows then
    cmd_exec = "haskell-language-server-wrapper.exe"
end

config.cmd = {cmd_exec}

local function install_script()
    if os.get_os() == os.OSes.Windows then
        return [[
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        function get_latest_version() {
            $response = Invoke-RestMethod -Uri "https://api.github.com/repos/haskell/haskell-language-server/releases/latest"
            return $response.tag_name
        }

        $version = get_latest_version
        $url = "https://github.com/haskell/haskell-language-server/releases/download/$($version)/haskell-language-server-wrapper-Windows.exe.zip"
        $out = "hls.zip"
        
        if (Test-Path -Path Get-Location) {
            Remove-Item Get-Location -Force -Recurse
        }
        
        Invoke-WebRequest -Uri $url -OutFile $out
        
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($out, "hls")
        
        Remove-Item $out

        Out-File -FilePath VERSION -Encoding string -InputObject "$($version)"
        ]]
    end
    return [[
    if ! command -v jq &> /dev/null
    then
        exit 123
    fi

    os=$(uname -s | tr "[:upper:]" "[:lower:]")
    version=$(curl -s "https://api.github.com/repos/haskell/haskell-language-server/releases/latest" | jq -r '.tag_name')

    case $os in
    linux)
    platform="Linux"
    ;;
    darwin)
    platform="macOS"
    ;;
    esac

    curl -L -o "hls.gz" "https://github.com/haskell/haskell-language-server/releases/download/$version/haskell-language-server-wrapper-$platform.gz"
    gzip -d hls.gz

    chmod +x hls

    echo $version > VERSION
    ]]
end

return {
    config = config,

    install_script = install_script,

    update_script = function()
        return installers.manual.update_script("haskell/haskell-language-server")
    end,
}
