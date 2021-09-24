local lsp_name = "omnisharp"
local config = require("lspmanager.utilities").get_config(lsp_name)
local os = require("lspmanager.os")

local cmd_exec = ""
if os.get_os() == os.OSes.Windows then
    cmd_exec = "./OmniSharp.exe"
else
    cmd_exec = "./run"
end

config.default_config.cmd = { cmd_exec, "--languageserver", "--hostPID", tostring(vim.fn.getpid()) }

local function install_script()
    if os.get_os() == os.OSes.Windows then
        return [[
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        function get_latest_version() {
            $response = invoke-restmethod -uri "https://api.github.com/repos/omnisharp/omnisharp-roslyn/releases/latest"
            return $response.tag_name
        }

        $version = get_latest_version
        $url = "https://github.com/OmniSharp/omnisharp-roslyn/releases/download/$($version)/omnisharp-win-x64.zip"
        $out = "omnisharp.zip"
        
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
    version=$(curl -s "https://api.github.com/repos/OmniSharp/omnisharp-roslyn/releases/latest" | jq -r '.tag_name')

    case $os in
    linux)
    platform="linux-x64"
    ;;
    darwin)
    platform="osx"
    ;;
    esac

    curl -L -o "omnisharp.zip" https://github.com/OmniSharp/omnisharp-roslyn/releases/download/$version/omnisharp-$platform.zip
    unzip omnisharp.zip
    rm omnisharp.zip
    chmod +x run
    echo $version > VERSION
    ]]
end

return vim.tbl_extend("error", config, {
    on_new_config = function(new_config, new_root_dir)
        if new_root_dir ~= nil then
            table.insert(new_config.cmd, "-s")
            table.insert(new_config.cmd, new_root_dir)
        end
    end,

    install_script = install_script,

    update_script = function()
        return require("lspmanager.installers.manual").update_script("OmniSharp/omnisharp-roslyn")
    end,
})
