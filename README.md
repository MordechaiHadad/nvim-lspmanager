Experimental lspmanager for neovim

Big thanks to [lspinstall](https://github.com/kabouzeid/nvim-lspinstall)  for helping me save time for some scripts

## Installation

```lua
use {
    'MordechaiHadad/nvim-lspmanager',
    requires = {'neovim/nvim-lspconfig', 'nvim-lua/plenary.nvim'},
    branch = "dev",
    config = function()
        require('lspmanager').setup()
        require("configs.lsp")
    end,
    requires = {
        "neovim/nvim-lspconfig",
        "ray-x/lsp_signature.nvim",
    }
}
```

### Added gdscript support, which u do not need to install or update cuz it comes bundled with godot itself
