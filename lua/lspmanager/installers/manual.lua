local manual = {}

function manual.update_script(link)
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
