local lsp_name = "tailwindcss"
local config = require("lspmanager.utilities").get_config(lsp_name)

config.default_config.cmd[1] = "./node_modules/.bin/tailwindcss-language-server"

return vim.tbl_extend("error", config, {
    install_script = function()
        return require("lspmanager.installers.npm").install_script("@tailwindcss/language-server")
    end,

    update_script = function()
        return require("lspmanager.installers.npm").update_script()
    end,
})
