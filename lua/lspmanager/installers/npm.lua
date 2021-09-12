local npm = {}

function npm.install_script(args) -- TODO: Change it from string to a table
    return [[
    ! test -f package.json && npm init -y --scope=lspmanager || true
    npm install ]] .. args
end

function npm.update_script()
    return [[
    if [ $(npm outdated) ]; then
        npm update
    else
        exit 69
    fi
    ]]
end

return npm
