local lsp_name = "solang"
local config = require("lspmanager.utilities").get_config(lsp_name)
local os = require("lspmanager.os")

local cmd_exec = "./solang"
if os.get_os() == os.OSes.Windows then
    cmd_exec = cmd_exec .. ".exe"
end

config.cmd = {cmd_exec}

local function install_script()
    if os.get_os() == os.OSes.Windows then
        return [[
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        function get_latest_version() {
            $response = invoke-restmethod -uri "https://api.github.com/repos/hyperledger-labs/solang/releases/latest"
            return $response.tag_name
        }

        $version = get_latest_version
        $url = "https://github.com/hyperledger-labs/solang/releases/download/$($version)/solang.exe"
        $out = "solang.exe"
        
        if (Test-Path -Path Get-Location) {
            Remove-Item Get-Location -Force -Recurse
        }

        Invoke-WebRequest -Uri $url -OutFile $out
        
        Out-File -FilePath VERSION -Encoding string -InputObject "$($version)"
        ]]
    end
    return [[
    if ! command -v jq &> /dev/null
    then
        exit 123
    fi

    os=$(uname -s | tr "[:upper:]" "[:lower:]")
    architecture=$(uname -m | tr "[:upper:]" "[:lower:]")
    version=$(curl -s "https://api.github.com/repos/hyperledger-labs/solang/releases/latest" | jq -r '.tag_name')

    case $os in
    linux)
    platform="linux"
    ;;
    darwin)
    platform="mac-intel"
    ;;
    esac

    if [ $architecture = "arm64" ]; then
        platform="mac-arm"
    fi

    curl -L -o "solang" "https://github.com/hyperledger-labs/solang/releases/download/v0.1.8/solang-$platform"

    if [ $os == "darwin" ]; then
        xattr -d com.apple.quarantine solang
    fi

    chmod +x solang
    echo $version > VERSION
    ]]
end

return {
    config = config,

    install_script = install_script,

    update_script = function()
        return require("lspmanager.installers.manual").update_script("hyperledger-labs/solang")
    end,
}
