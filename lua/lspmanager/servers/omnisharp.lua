local lsp_name = "omnisharp"
local config = require("lspmanager.utilities").get_config(lsp_name)

config.default_config.cmd = { "./run", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) }

local function install_script()
    return [[
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
