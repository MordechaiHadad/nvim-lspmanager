local package_managers = {
    npm = require("lspmanager.installers.npm"),
    manual = require("lspmanager.installers.manual"),
    pip = require("lspmanager.installers.pip"),
}

return package_managers
