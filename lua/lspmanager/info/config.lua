local config = {}
config.options = {
	header = {
    [[|  _._  ._ _  _.._  _. _  _ ._]],
    [[|__>|_) | | |(_|| |(_|(_|(/_| ]],
    [[    |                  _|     ]],
	},
	levels = { "◈  ", "◇ ", " " },
}

config.setup = function (opts)
	config.options = vim.tbl_deep_extend("force", config.options, opts or {})
end
return config
