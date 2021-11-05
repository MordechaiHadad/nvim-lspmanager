# Nvim-lspmanager

Nvim-lspmanager is a powerful and extensible manager for LSPs (Language Server Protocols).
Using pre-made configurations from [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig), you can be sure that your lsp will work without having to write a single line of code.

## :star2: Features

- 3 simple commands missing from native neovim Lsp integration (LspInstall, LspUninstall, LspUpdate)
- Lots of supported language servers
- Uses [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) to require configurations for each lsp
- No need to reload neovim after installing a lsp
- Fully supports windows

## :wrench: Installation
Make sure to use Neovim version 0.5.x or higher.
#### Dependencies
Make sure you have the following packages installed (some dependencies are responsible for others i.e dotnet LSPs download via `dotnet`):

<details>
    <summary>Unix</summary>

- [`jq`](https://github.com/stedolan/jq)
- [`curl`](https://github.com/curl/curl)
- [`npm`](https://github.com/npm/cli)
- [`gzip`](https://github.com/nicklockwood/GZIP)
- `unzip`
- [`pip`](https://github.com/pypa/pip)
- [`dotnet`](https://github.com/microsoft/dotnet)
- [`go`](https://github.com/golang/go)

</details>

<details>
    <summary>Windows</summary>

- [`npm`](https://github.com/npm/cli)
- [`dotnet`](https://github.com/microsoft/dotnet)
- [`pip`](https://github.com/pypa/pip)
- [`go`](https://github.com/golang/go)

</details>

- [Packer](https://github.com/wbthomason/packer.nvim)
```lua
use {
    'MordechaiHadad/nvim-lspmanager',
    requires = {'neovim/nvim-lspconfig'},
    config = function()
        require('lspmanager').setup()
    end,
}
```
Resource the current file, and run `:PackerInstall` to install the plugin.

- [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'MordechaiHadad/nvim-lspmanager' | Plug 'neovim/nvim-lspconfig'
```
Resource the current file, and run `:PlugInstall` to install the plugin.

Now you can place this base configuration in your `init.vim` file:
```vim
lua << EOF
    require('lspmanager').setup()
EOF
```

## :question: Usage

- `:LspInstall ...`: Installs a supported language server
- `:LspUninstall ...:` Uninstall an installed language server
- `:LspUpdate ...`: Update an installed language server. (`:LspUpdate all` will update all installed ones)

### Telescope picker

nvim-lspmanager integrates [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) to install, uninstall and update language servers.

- `:Telescope lspmanager` is used for selecting either one of these options: `lsp_install`, `lsp_uninstall`, `lsp_update`

## :white_check_mark: Supported language servers

|                    | Language                                       | Language server     |
| :----------------- | :--------------------------------------------- | :--------------------------------------------------------------------------- |
| :white_check_mark: | Angular                                        | `angularls`         |
| :white_check_mark: | Bash                                           | `bashls`            |
| :white_check_mark: | C/C++                                          | `clangd`            |
| :white_check_mark: | Clojure                                        | `clojure_lsp`       |
| :white_check_mark: | CMake                                          | `cmake`             |
| :white_check_mark: | CSS                                            | `cssls`             |
| :white_check_mark: | Docker                                         | `dockerls`          |
| :white_check_mark: | Elixir                                         | `elixirls`          |
| :white_check_mark: | Emmet                                          | `emmet_ls`          |
| :white_check_mark: | FSharp                                         | `fsautocomplete`    |
| :white_check_mark: | Haskell                                        | `hls`               |
| :white_check_mark: | HTML                                           | `html`              |
| :white_check_mark: | JSON                                           | `jsonls`            |
| :white_check_mark: | Kotlin                                         | `kotlinls`          |
| :white_check_mark: | CSharp                                         | `omnisharp`         |
| :white_check_mark: | PureScript                                     | `purescriptls`      |
| :white_check_mark: | Python                                         | `pyright`           |
| :white_check_mark: | Rust                                           | `rust_analyser`     |
| :white_check_mark: | Solidity                                       | `solang`            |
| :white_check_mark: | Lua                                            | `sumneko_lua`       |
| :white_check_mark: | Svelte                                         | `sveltels`          |
| :white_check_mark: | Tailwindcss                                    | `tailwindcssls`     |
| :white_check_mark: | Terraform                                      | `terraformls`       |
| :white_check_mark: | LaTex                                          | `texlab`            |
| :white_check_mark: | Javascript/Typescript                          | `tsserver`          |
| :white_check_mark: | VimL                                           | `vimls`             |
| :white_check_mark: | Volar                                          | `volar`           |
| :white_check_mark: | Vuejs                                          | `vuels`             | 

## :heart: Credits

- Big thanks to [lspinstall](https://github.com/kabouzeid/nvim-lspinstall) which is the mother plugin of lspmanager.
