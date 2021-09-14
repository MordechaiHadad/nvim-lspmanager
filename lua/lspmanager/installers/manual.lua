local manual = {}

local os = require("lspmanager.os")

function manual.update_script(link)
    if os.get_os() == os.OSes.Windows then
        return [[
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        function get_latest_version() {
            $response = invoke-restmethod -uri "https://api.github.com/repos/]] .. link .. [[/releases/latest" 
            return $response.tag_name
        }

        $installed_version = type VERSION
        $upstream_version = get_latest_version

        if ($installed_version -eq $upstream_version) {
            exit 69
        }
        exit 70
    ]]
    end
    return [[
installed_version=$(cat VERSION)
upstream_version=$(curl -s https://api.github.com/repos/]] .. link .. [[/releases/latest | jq -r '.tag_name')

if [ "$installed_version" = "$upstream_version" ]; then
    exit 69
else
    exit 70
fi
    ]]
end

return manual
