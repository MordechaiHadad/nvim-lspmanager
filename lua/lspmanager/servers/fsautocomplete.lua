local lsp_name = "fsautocomplete"
local config = require("lspmanager.utilities").get_config(lsp_name)

config.default_config.cmd[2] = "fsautocomplete"

local function install_script()
    return [[
    dotnet new tool-manifest
    dotnet tool install fsautocomplete
    ]]
end

return vim.tbl_extend("error", config, {
    install_script = install_script,

    update_script = function()
        return [[
        dotnet tool update fsautocomplete
        ]]
    end,
})
