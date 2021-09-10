Experimental lspmanager for neovim

Big thanks to [lspinstall](https://github.com/kabouzeid/nvim-lspinstall)  for helping me save time for some scripts

## Installation

```lua
use {'MordechaiHadad/nvim-lspmanager', requires = {'neovim/nvim-lspconfig', 'nvim-lua/plenary.nvim'}, config = function()
    require('lspmanager').setup()
end}
```

### Now supports vscode Language servers, please do not attempt to use them yet. they are wacked for some reason out of my control
