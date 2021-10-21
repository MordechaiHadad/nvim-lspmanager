local npm = {}

local os = require("lspmanager.os")

function npm.install_script(args)
    if os.get_os() == os.OSes.Windows then
        return [[
        if(-not(Test-Path -Path 'package.json' -PathType Leaf)) {
            npm init -y --scope=lspmanager
        }
        npm install ]] .. table.concat(args, " ") ..
        [[ 

        exit $LASTEXITCODE
        ]]
    end
    return [[
    ! test -f package.json && npm init -y --scope=lspmanager || true
    npm install ]] .. table.concat(args, " ")
end

function npm.update_script()
    if os.get_os() == os.OSes.Windows then
        return [[
        $result = $null
        $result = Invoke-Expression 'npm outdated'

        if ($result -ne $null) {
            npm update
            exit 0
        }
        else {
            exit 69
        }
        ]]
    end
    return [[
    if [ $(npm outdated) ]; then
        npm update
    else
        exit 69
        fi
        ]]
end

return npm
