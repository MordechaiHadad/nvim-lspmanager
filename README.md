# Nvim-lspmanager

Nvim-lspmanager is a powerful and extensible manager for LSPs (Language Server Protocols).
Using pre-made configurations from [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig), you can be sure that your lsp will work without having to write a single line of code.

## Features

- 3 simple commands missing from native neovim Lsp integration (LspInstall, LspUninstall, LspUpdate)
- Lots of supported language servers
- Uses [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) to require configurations for each lsp
- No need to reload neovim after installing a lsp
- Fully supports windows

## Installation
#### Dependencies
Make sure you have [`jq`](https://github.com/stedolan/jq), [`curl`](https://github.com/curl/curl), [`npm`](https://github.com/npm/cli), [`gzip`](https://github.com/nicklockwood/GZIP), and [`unzip`]() installed.

##### Install instructions for dependencies
instructions for jq, curl, npm and gzip are given in their github repo

```bash
# unzip

# For Arch or arch-based linux distros
❯ sudo pacman -S unzip

# Debian / Ubuntu based linux distros
❯ sudo apt install unzip

# MacoS
❯ brew install unzip

# Windows
❯ choco install unzip
```

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

## Usage

- `:LspInstall ...`: Installs a supported language server
- `:LspUninstall ...:` Uninstall an installed language server
- `:LspUpdate ...`: Update an installed language server. (`:LspUpdate all` will update all installed ones)

## Supported language servers

|                    | Language                                       | Language server |
| :----------------- | :--------------------------------------------- | :--------------------------------------------------------------------------- |
| :white_check_mark: | Angular                                        | `angularls` |
| :white_check_mark: | C/C++                                          | `clangd` |
| :white_check_mark: | CSS                                            | `cssls` |
| :white_check_mark: | Csharp                                         | `omnisharp` |
| :white_check_mark: | Docker                                         | `dockerls` |
| :white_check_mark: | Fsharp                                         | `fsautocomplete` |
| :white_check_mark: | HTML                                           | `html` |
| :white_check_mark: | JSON                                           | `jsonls` |
| :white_check_mark: | Javascript/Typescript                          | `tsserver` |
| :white_check_mark: | Lua                                            | `sumneko_lua` |
| :white_check_mark: | Python                                         | `pyright` |
| :white_check_mark: | Rust                                           | `rust_analyser` |
| :white_check_mark: | Svelte                                         | `sveltels` |
| :white_check_mark: | Tailwindcss                                    | `tailwindcssls` |
| :white_check_mark: | Vuejs                                          | `vuels` | 

## Credits

- Big thanks to [lspinstall](https://github.com/kabouzeid/nvim-lspinstall)  for helping me save time for some scripts
