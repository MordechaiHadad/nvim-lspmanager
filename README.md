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

## Usage

- `:LspInstall ...`: Installs a supported language server
- `:LspUninstall ...:` Uninstall an installed language server
- `:LspUpdate ...`: Update an installed language server. (`:LspUpdate all` will update all installed ones)

## Supported language servers

|                    | Language                                       | Language server |
| :----------------- | :--------------------------------------------- | :--------------------------------------------------------------------------- |
| :white_check_mark: | Angular                                        | `angularls` |
| :white_check_mark: | C                                     | `clangd` |
| :white_check_mark: | Csharp | `omnisharp` |
| :white_check_mark: | CSS                                           | `cssls` |
| :white_check_mark: | Fsharp                                         | `fsautocomplete` |
| :white_check_mark: | HTML                                           | `html` | 
| :white_check_mark: | Javascript/Typescript                          | `tsserver` |
| :white_check_mark: | JSON | `jsonls` |
| :white_check_mark: | Lua                                            | `sumneko_lua` |
| :white_check_mark: | Python                                         | `pyright` |
| :white_check_mark: | Rust | `rust_analyser` |
| :white_check_mark: | Svelte | `sveltels` |
| :white_check_mark: | Tailwindcss | `tailwindcssls` |
| :white_check_mark: | Vuejs | `vuels` |

