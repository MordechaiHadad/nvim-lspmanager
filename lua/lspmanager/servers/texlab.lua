local lsp_name = "texlab"
local config = require("lspmanager.utilities").get_config(lsp_name).document_config.default_config
local os = require("lspmanager.os")

local cmd_exec = "./texlab"
if os.get_os() == os.OSes.Windows then
    cmd_exec = cmd_exec .. ".exe"
end

config.cmd[1] = cmd_exec

local function install_script()
    if os.get_os() == os.OSes.Windows then
        return [[
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        function get_latest_version() {
            $response = invoke-restmethod -uri "https://api.github.com/repos/latex-lsp/texlab/releases/latest"
            return $response.tag_name
        }

        $version = get_latest_version
        $url = "https://github.com/latex-lsp/texlab/releases/download/$($version)/texlab-x86_64-windows.zip"
        $out = "texlab.zip"
        
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
    architecture=$(uname -m | tr "[:upper:]" "[:lower:]")
    version=$(curl -s "https://api.github.com/repos/latex-lsp/texlab/releases/latest" | jq -r '.tag_name')

    case $os in
    linux)
    platform="linux"
    ;;
    darwin)
    platform="macos"
    ;;
    esac

    curl -L -o "texlab.tar.gz" "https://github.com/latex-lsp/texlab/releases/download/$version/texlab-x86_64-$platform.tar.gz"

    tar -xf texlab.tar.gz
    rm -rf texlab.tar.gz

    echo $version > VERSION
    ]]
end

return {
    config = config,

    install_script = install_script,

    update_script = function()
        return require("lspmanager.installers.manual").update_script("latex-lsp/texlab")
    end,
}
