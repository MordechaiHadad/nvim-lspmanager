local lsp_name = "clangd"
local config = require("lspmanager.utilities").get_config(lsp_name)

config.default_config.cmd[1] = "./clangd/bin/clangd"

local function install_script()
    return [[
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
    unzip clangd.zip

    rm clangd.zip
    mv clangd_* clangd

    echo $version > VERSION
    ]]
end

return vim.tbl_extend("error", config, {
    install_script = install_script,

    update_script = function()
        return require("lspmanager.package_managers.manual").update_script("clangd/clangd")
    end,
})
