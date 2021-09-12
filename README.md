Experimental lspmanager for neovim

Big thanks to [lspinstall](https://github.com/kabouzeid/nvim-lspinstall)  for helping me save time for some scripts

## Installation

```lua
use {'MordechaiHadad/nvim-lspmanager', requires = {'neovim/nvim-lspconfig', 'nvim-lua/plenary.nvim'}, config = function()
    require('lspmanager').setup()
end}
```
### As usual f# lsp really doesnt like to work so dont even try to us
