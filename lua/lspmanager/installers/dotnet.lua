local dotnet = {}

local os = require("lspmanager.os")

function dotnet.install_script(name)
    if os.get_os() == os.OSes.Windows then
        return [[

        exit $LASTEXITCODE]]
    end
    return "lsp=" .. name .. "\n" ..
    [[dotnet new tool-manifest
    dotnet tool install $lsp

    version=$(curl -s "https://api.nuget.org/v3-flatcontainer/$lsp/index.json" | jq -r '.versions[-1]')
    echo $version > VERSION]]
end

function dotnet.update_script(name)
    if os.get_os() == os.OSes.Windows then
        return [[
        ]]
    end
    return "lsp=" .. name .. "\n" ..
    [[installed_version=$(cat VERSION)
    upstream_version=$(curl -s "https://api.nuget.org/v3-flatcontainer/$lsp/index.json" | jq -r '.versions[-1]')


    if [ "$installed_version" = "$upstream_version" ]; then
        exit 69
    else
        dotnet tool update $lsp
    fi
    ]]
end

return dotnet
