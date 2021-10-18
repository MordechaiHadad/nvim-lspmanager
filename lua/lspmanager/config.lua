--- @class config
local config = {}

local configurations = {
  angularls = require("lspmanager.servers.angularls"),
  bashls = require("lspmanager.servers.bashls"),
  clangd = require("lspmanager.servers.clangd"),
  cmake = require("lspmanager.servers.cmake"),
  cssls = require("lspmanager.servers.cssls"),
  dockerls = require("lspmanager.servers.dockerls"),
  emmet_ls = require("lspmanager.servers.emmet_ls"),
  fsautocomplete = require("lspmanager.servers.fsautocomplete"),
  html = require("lspmanager.servers.html"),
  jdtls = require("lspmanager.servers.jdtls"),
  jsonls = require("lspmanager.servers.jsonls"),
  omnisharp = require("lspmanager.servers.omnisharp"),
  pyright = require("lspmanager.servers.pyright"),
  rust_analyzer = require("lspmanager.servers.rust_analyzer"),
  sumneko_lua = require("lspmanager.servers.sumneko_lua"),
  svelte = require("lspmanager.servers.svelte"),
  tailwindcss = require("lspmanager.servers.tailwindcss"),
  tsserver = require("lspmanager.servers.tsserver"),
  vuels = require("lspmanager.servers.vuels"),
}

--- Get a configuration value
--- @param opt string
--- @return any
config.get = function(opt)
  if opt then
    return configurations[opt]
  end
  return configurations
end

--- Set user-defined configurations
--- @param user_configs table
--- @return table
config.set = function(user_configs)
  vim.validate({ user_configs = { user_configs, "table" } })

  configurations = vim.tbl_deep_extend("force", configurations, user_configs)
  return configurations
end

return config
