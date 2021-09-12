local package_managers = {
    ["npm"] = require("lspmanager.package_managers.npm"),
    ["manual"] = require("lspmanager.package_managers.manual"),
}

return package_managers
