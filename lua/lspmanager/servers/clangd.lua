local lsp_name = "clangd"
local config = require("lspmanager.utilities").get_config(lsp_name)
local installers = require("lspmanager.installers")
local os = require("lspmanager.os")

local cmd_exec = "./bin/clangd"

if os.get_os == os.OSes.Windows then
    cmd_exec = cmd_exec .. ".exe"
end

config.cmd = {cmd_exec}

local function install_script()
    if os.get_os() == os.OSes.Windows then
        return [[
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        function get_latest_version() {
            $response = Invoke-RestMethod -Uri "https://api.github.com/repos/clangd/clangd/releases/latest"
            return $response.tag_name
        }

        $version = get_latest_version
        $url = "https://github.com/clangd/clangd/releases/download/$($version)/clangd-windows-$($version).zip"
        $out = "clangd.zip"
        
        if (Test-Path -Path Get-Location) {
            Remove-Item Get-Location -Force -Recurse
        }
        
        Invoke-WebRequest -Uri $url -OutFile $out
        
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($out, ".")
        
        Remove-Item $out
        
        $cwd = Get-Location
        
        Set-Location -Path clangd\clangd_$version
        Get-ChildItem -Recurse | Move-Item -Destination $cwd
        Set-Location -Path $cwd\clangd
        Remove-Item clangd_$version

        Set-Location -Path $cwd

        Out-File -FilePath VERSION -Encoding string -InputObject "$($version)"
        ]]
    end
    return [[
    if ! command -v jq &> /dev/null
    then
        exit 123
    fi

    os=$(uname -s | tr "[:upper:]" "[:lower:]")
    version=$(curl -s "https://api.github.com/repos/clangd/clangd/releases/latest" | jq -r '.tag_name')

    case $os in
    linux)
    platform="linux"
    ;;
    darwin)
    platform="mac"
    ;;
    esac

    curl -L -o "clangd.zip" "https://github.com/clangd/clangd/releases/download/$version/clangd-$platform-$version.zip"
    unzip clangd.zip -d .

    rm clangd.zip
    mv clangd_*/* .

    echo $version > VERSION
    ]]
end

return {
    config = config,

    install_script = install_script,

    update_script = function()
        return installers.manual.update_script("clangd/clangd")
    end,
}
