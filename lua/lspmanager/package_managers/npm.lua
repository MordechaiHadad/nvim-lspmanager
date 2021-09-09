local npm = {}

function npm.install_script(args)
	return [[
    ! test -f package.json && npm init -y --scope=lspmanager || true
    npm install ]] .. args
end

function npm.update_script() end

return npm
