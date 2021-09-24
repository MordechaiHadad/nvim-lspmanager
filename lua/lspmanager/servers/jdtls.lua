local lsp_name = "jdtls"
local config = require("lspmanager.utilities").get_config(lsp_name)
local installers = require("lspmanager.installers")
local os = require("lspmanager.os")
local path = require("lspmanager.utilities").get_path(lsp_name)

local function install_script()
    if os.get_os() == os.OSes.Windows then
        return [[

        ]] -- NOTE: This is gonna be pain
    end

    return [[
    curl https://raw.githubusercontent.com/eruizc-dev/jdtls-launcher/master/install.sh | bash -s ]] .. path .. "\n" .. [[


    ]]
end

return vim.tbl_extend("error", config, {
    install_script = install_script,
})
