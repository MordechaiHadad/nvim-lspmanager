local pip = {}

local os = require("lspmanager.os")

function pip.install_script(args) -- TODO: Change it from string to a table
    if os.get_os() == os.OSes.Windows then
        return [[

        python -m venv ./venv
        .\venv\Scripts\pip3.exe install -U pip
        .\venv\Scripts\pip3.exe install -U ]] .. table.concat(args, " ") ..
        [[ 

        exit $LASTEXITCODE
        ]]
    end
    return [[
    python3 -m venv ./venv
    ./venv/bin/pip3 install -U pip
    ./venv/bin/pip3 install -U ]] .. table.concat(args, " ")
end

function pip.update_script(args)
    if os.get_os() == os.OSes.Windows then
        return [[

        $output = $(.\venv\Scripts\pip3.exe list --outdated)

        $server = "]] .. table.concat(args, " ") .. '"' ..

        [[

        if ($output | Select-String -Pattern $server) {
            .\venv\Scripts\pip3.exe install -U $server
            exit 0
        }
         exit 69

        ]]
    end
    return [[
    output=$(venv/bin/pip list --outdated)

    server="]] .. table.concat(args, " ") .. '"' ..

    [[
    
    if echo $output | grep server > /dev/null; then
        ./venv/bin/pip3 install -U $server
        exit 0
    fi
    exit 69
    ]]
end

return pip
