local lsp_name = "sumneko_lua"
local config = require("lspmanager.utilities").get_config(lsp_name)

config.default_config.cmd = { "./sumneko-lua-language-server" }

local function install_script()
    return [[
    os=$(uname -s | tr "[:upper:]" "[:lower:]")
    version=$(curl -s "https://api.github.com/repos/sumneko/vscode-lua/releases/latest" | jq -r '.tag_name')

    case $os in
    linux)
    platform="Linux"
    ;;
    darwin)
    platform="macOS"
    ;;
    esac

    curl -L -o "sumneko-lua.vsix" "https://github.com/sumneko/vscode-lua/releases/download/$version/lua-$(echo $version | sed 's/v//').vsix"
    rm -rf sumneko-lua
    unzip sumneko-lua.vsix -d sumneko-lua
    rm sumneko-lua.vsix

    chmod +x sumneko-lua/extension/server/bin/$platform/lua-language-server

    echo "#!/usr/bin/env bash" > sumneko-lua-language-server
    echo "\$(dirname \$0)/sumneko-lua/extension/server/bin/$platform/lua-language-server -E -e LANG=en \$(dirname \$0)/sumneko-lua/extension/server/main.lua \$*" >> sumneko-lua-language-server
    chmod +x sumneko-lua-language-server

    echo $version > VERSION
    ]]
end

return vim.tbl_extend("error", config, {
    install_script = install_script,

    update_script = function ()
        return require("lspmanager.package_managers.manual").update_script("sumneko/vscode-lua")
    end
})
