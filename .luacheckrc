stds.nvim = {
  globals = {
    vim = { fields = { "g" } },
    table = { fields = { "unpack" } },
    package = { fields = { "searchers" } },
  },
  read_globals = {
    "vim",
    "jit",
  },
}
std = "lua51+nvim"

-- Rerun tests only if their modification time changed.
cache = true
unused = false

ignore = {
  "212/_.*", -- Unused argument, for variables with "_" prefix.
  "331", -- Value assigned to a local variable is mutated but never accessed.
  "631", -- Line is too long.
}
