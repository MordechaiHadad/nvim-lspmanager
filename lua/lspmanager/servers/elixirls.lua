local lsp_name = "elixirls"
local config = require("lspmanager.utilities").get_config(lsp_name)
local installers = require("lspmanager.installers")
local os = require("lspmanager.os")

local cmd_exec = "./language_server"

if os.get_os == os.OSes.Windows then
    cmd_exec = cmd_exec .. ".bat"
else
    cmd_exec = cmd_exec .. ".sh"
end

config.default_config.cmd = { cmd_exec }

local function install_script()
    if os.get_os() == os.OSes.Windows then
        return [[
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        function get_latest_version() {
            $response = Invoke-RestMethod -Uri "https://api.github.com/repos/elixir-lsp/elixir-ls/releases/latest"
            return $response.tag_name
        }

        $version = get_latest_version
        $url = "https://github.com/elixir-lsp/elixir-ls/releases/download/$($version)/elixir-ls.zip"
        $out = "elixir-ls.zip"
        
        if (Test-Path -Path Get-Location) {
            Remove-Item Get-Location -Force -Recurse
        }
        
        Invoke-WebRequest -Uri $url -OutFile $out
        
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($out, ".")
        
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
    version=$(curl -s "https://api.github.com/repos/elixir-lsp/elixir-ls/releases/latest" | jq -r '.tag_name')

    curl -L -o "elixir-ls.zip" "https://github.com/elixir-lsp/elixir-ls/releases/download/$version/elixir-ls.zip"
    unzip elixir-ls.zip

    rm elixir-ls.zip

    echo $version > VERSION
    ]]
end

return {
    config = config,

    install_script = install_script,

    update_script = function()
        return installers.manual.update_script("elixir-lsp/elixir-ls")
    end,
}
