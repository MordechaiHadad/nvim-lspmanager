local pip = {}

local os = require("lspmanager.os")

function pip.install_script(args) -- TODO: Change it from string to a table
    if os.get_os() == os.OSes.Windows then
        return [[

        Invoke-Expression 'python3 -m venv ./venv'
        Invoke-Expression './venv/bin/pip3 install -U pip'
        Invoke-Expression './venv/bin/pip3 install -U ]] .. table.concat(args, " ") .. "'\n" .. [[ exit $LASTEXITCODE
        ]]
    end
    return [[
    python3 -m venv ./venv
    ./venv/bin/pip3 install -U pip
    ./venv/bin/pip3 install -U ]] .. table.concat(args, " ")
end

return pip
