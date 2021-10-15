local dotnet = {}

local os = require("lspmanager.os")

function dotnet.install_script(name)
    if os.get_os() == os.OSes.Windows then
        return [[
        $lsp = "]] .. name .. '"\n' .. [[
        Invoke-Expression 'dotnet new tool-manifest'
        Invoke-Expression 'dotnet tool install $($lsp)'

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        function get_latest_version() {
            $response = invoke-restmethod -uri "https://api.nuget.org/v3-flatcontainer/$($lsp)/index.json"
            return $response.versions
        }

        $version = get_latest_version
        Out-File -FilePath VERSION -Encoding string -InputObject "$($version[-1])"

        exit $LASTEXITCODE]]
    end
    return "lsp="
        .. name
        .. "\n"
        .. [[dotnet new tool-manifest
    dotnet tool install $lsp

    version=$(curl -s "https://api.nuget.org/v3-flatcontainer/$lsp/index.json" | jq -r '.versions[-1]')
    echo $version > VERSION]]
end

function dotnet.update_script(name)
    if os.get_os() == os.OSes.Windows then
        return [[
        $lsp = "]] .. name .. '"\n' .. [[
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        function get_latest_version() {
            $response = invoke-restmethod -uri "https://api.nuget.org/v3-flatcontainer/$($lsp)/index.json"
            return $response.versions
        }

        $installed_version = type VERSION
        $upstream_version = get_latest_version

        if ($installed_version -eq $upstream_version[-1]) {
            exit 69
        }
        exit 70]]
    end
    return "lsp="
        .. name
        .. "\n"
        .. [[installed_version=$(cat VERSION)
    upstream_version=$(curl -s "https://api.nuget.org/v3-flatcontainer/$lsp/index.json" | jq -r '.versions[-1]')


    if [ "$installed_version" = "$upstream_version" ]; then
        exit 69
    else
        dotnet tool update $lsp
    fi
    ]]
end

return dotnet
