local lsp_name = "terraformls"
local config = require("lspmanager.utilities").get_config(lsp_name)
local os = require("lspmanager.os")

local cmd_exec = "./terraform-ls"

if os.get_os() == os.OSes.Windows then
    cmd_exec = cmd_exec .. ".exe"
end

config.cmd = cmd_exec

local function install_script()
    if os.get_os() == os.OSes.Windows then
        return [[
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        function get_latest_version() {
            $response = invoke-restmethod -uri "https://api.github.com/repos/hashicorp/terraform-ls/releases/latest"
            return $response.tag_name
        }

        $version = get_latest_version
        $otherversion = $version.Trim("v")

        $url = "https://github.com/hashicorp/terraform-ls/releases/download/$($version)/terraform-ls_$($otherversion)_windows_amd64.zip"
        $out = "terraformls.zip"
        
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
    version=$(curl -s "https://api.github.com/repos/hashicorp/terraform-ls/releases/latest" | jq -r '.tag_name')

    case $os in
    linux)
    platform="linux_amd64"
    ;;
    darwin)
    platform="darwin_amd64"
    ;;
    esac

    curl -L -o "terraformls.zip" https://github.com/hashicorp/terraform-ls/releases/download/$version/terraform-ls_$(echo $version | sed 's/v//')_$platform.zip
    unzip terraformls.zip
    rm terraformls.zip

    echo $version > VERSION
    ]]
end

return {
    config = config,

    install_script = install_script,

    update_script = function()
        return require("lspmanager.installers.manual").update_script("hashicorp/terraform-ls")
    end,
}
