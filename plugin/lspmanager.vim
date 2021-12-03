function! lspmanager#install_server(lang)
  call v:lua.require("lspmanager").install(a:lang)
endfunction

function! lspmanager#update_server(lang, ...)
    call v:lua.require("lspmanager").update(a:lang)
endfunction

function! lspmanager#uninstall_server(lang)
  call v:lua.require("lspmanager").uninstall(a:lang)
endfunction

function! lspmanager#available_servers() abort
  return luaeval('require("lspmanager").available_servers()')
endfunction

function! lspmanager#installed_servers() abort
  return luaeval('require("lspmanager").installed_servers()')
endfunction

function! lspmanager#installed_servers_for_update() abort
    return luaeval('require("lspmanager").installed_servers({ insert_key_all = true })')
endfunction


function! lspmanager#is_lsp_installed(lang) abort
  return luaeval('require("lspmanager").is_lsp_installed("'.a:lang.'")')
endfunction

command! -nargs=* -complete=custom,s:complete_available LspInstall :call lspmanager#install_server('<args>')
command! -nargs=1 -complete=custom,s:complete_installed LspUninstall :call lspmanager#uninstall_server('<args>')
command! -nargs=1 -complete=custom,s:complete_installed_for_update LspUpdate :call lspmanager#update_server('<args>')
command! -nargs=0 LspInfo :lua require("lspmanager.info").display()

function! s:complete_available(arg, line, pos) abort
  return join(lspmanager#available_servers(), "\n")
endfunction

function! s:complete_installed(arg, line, pos) abort
  return join(lspmanager#installed_servers(), "\n")
endfunction

function! s:complete_installed_for_update(arg, line, pos) abort
  return join(lspmanager#installed_servers_for_update(), "\n")
endfunction
