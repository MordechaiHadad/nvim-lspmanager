local lsp_name = "rust_analyzer"
local config = require("lspmanager.utilities").get_config(lsp_name)

config.default_config.cmd[1] = "./rust-analyzer"

local function install_script()
    return [[
    os=$(uname -s | tr "[:upper:]" "[:lower:]")
    mchn=$(uname -m | tr "[:upper:]" "[:lower:]")
    version=$(curl -s "https://api.github.com/repos/rust-analyzer/rust-analyzer/releases/latest" | jq -r '.tag_name')

    if [ $mchn = "arm64" ]; then
        mchn="aarch64"
        fi

        case $os in
        linux)
        platform="unknown-linux-gnu"
        ;;
        darwin)
        platform="apple-darwin"
        ;;
        esac

        curl -L -o "rust-analyzer.gz" "https://github.com/rust-analyzer/rust-analyzer/releases/download/$version/rust-analyzer-$mchn-$platform.gz"
        gzip -d rust-analyzer.gz

        rm rust-analyzer.gz
        mv rust-analyzer-$mchn-$platform rust-analyzer

        chmod +x rust-analyzer
        echo $version > VERSION
        ]]
    end

    return vim.tbl_extend('error', config, {
        install_script = install_script,

        update_script = function ()
            return require("lspmanager.package_managers.manual").update_script("rust-analyzer/rust-analyzer")
        end
    })
