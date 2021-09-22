local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
  error("This plugin requires nvim-telescope/telescope.nvim")
end

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local manager = require("lspmanager")

local lspmanager = function(opts)
    pickers.new(opts, {
        prompt_title = "servers",
        finder = finders.new_table {
            results = manager.available_servers(),
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)

                local lsp = action_state.get_selected_entry()[1]

                manager.install(lsp)
            end)
            return true
        end,
    }):find()
end

lspmanager()

return telescope.register_extension({
  exports = { lspmanager = lspmanager },
})
