local package_managers = {
    npm = require("lspmanager.installers.npm"),
    manual = require("lspmanager.installers.manual"),
}

return package_managers
