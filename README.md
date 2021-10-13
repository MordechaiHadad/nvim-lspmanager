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
Make sure you have the following packages installed:

- `jq`
- `curl`
- `npm`
- `gzip`
- `unzip`
- `pip`

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
```lua
lua << EOF
    require('lspmanager').setup()
EOF
```

## Usage

- `:LspInstall ...`: Installs a supported language server
- `:LspUninstall ...:` Uninstall an installed language server
- `:LspUpdate ...`: Update an installed language server. (`:LspUpdate all` will update all installed ones)

## Supported language servers

|                    | Language                                       | Language server     |
| :----------------- | :--------------------------------------------- | :--------------------------------------------------------------------------- |
| :white_check_mark: | Angular                                        | `angularls`         |
| :white_check_mark: | Bash                                           | `bashls`            |
| :white_check_mark: | C/C++                                          | `clangd`            |
| :white_check_mark: | CMake                                          | `cmake`             |
| :white_check_mark: | CSS                                            | `cssls`             |
| :white_check_mark: | Docker                                         | `dockerls`          |
| :white_check_mark: | Elixir                                         | `elixirls`          |
| :white_check_mark: | Emmet                                          | `emmet_ls`          |
| :white_check_mark: | FSharp                                         | `fsautocomplete`    |
| :white_check_mark: | Haskell                                        | `hls`               |
| :white_check_mark: | HTML                                           | `html`              |
| :white_check_mark: | Java                                           | `jdtls`             |
| :white_check_mark: | JSON                                           | `jsonls`            |
| :white_check_mark: | Kotlin                                         | `kotlinls`          |
| :white_check_mark: | CSharp                                         | `omnisharp`         |
| :white_check_mark: | Python                                         | `pyright`           |
| :white_check_mark: | Rust                                           | `rust_analyser`     |
| :white_check_mark: | Lua                                            | `sumneko_lua`       |
| :white_check_mark: | Svelte                                         | `sveltels`          |
| :white_check_mark: | Tailwindcss                                    | `tailwindcssls`     |
| :white_check_mark: | Terraform                                      | `terraformls`       |
| :white_check_mark: | Javascript/Typescript                          | `tsserver`          |
| :white_check_mark: | VimL                                           | `vimls`             |
| :white_check_mark: | Vuejs                                          | `vuels`             | 

## Credits

- Big thanks to [lspinstall](https://github.com/kabouzeid/nvim-lspinstall) for helping me save time for some scripts
