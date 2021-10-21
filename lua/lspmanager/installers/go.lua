local go = {}

local os = require("lspmanager.os")

function go.install_script(args)
    if os.get_os() == os.OSes.Windows then
        return [[
        $env:GOPATH = $(pwd)
        $env:GOBIN = $(pwd)
        $env:GO111MODULE = "on"
        go get -v ]] .. table.concat(args, " ") ..
        [[

        go clean -modcache
        exit $LASTEXITCODE]]
    end
    return [[
    GOPATH=$(pwd) GOBIN=$(pwd) GO111MODULE=on go get -v ]] .. table.concat(args, " ") .. " \n" .. [[GOPATH=$(pwd) GO111MODULE=on go clean -modcache]]
end

function go.update_script(args)
    if os.get_os() == os.OSes.Windows then
        return [[
        $env:GOPATH = $(pwd)
        $env:GOBIN = $(pwd)
        $env:GO111MODULE = "on"
        go get -v ]] .. table.concat(args, " ") ..
        [[

        Invoke-Expression 'go clean -modcache'

        if ($LASTEXITCODE -eq 0) {
            exit 3
        }
        else {
            exit $LASTEXITCODE
        }]]
    end
    return [[
    GOPATH=$(pwd) GOBIN=$(pwd) GO111MODULE=on go get -v ]] .. table.concat(args, " ") .. " \n" .. [[GOPATH=$(pwd) GO111MODULE=on go clean -modcache

    if (($? == 0)); then
        exit 3
    else
        exit $?
    fi]]
end

return go
