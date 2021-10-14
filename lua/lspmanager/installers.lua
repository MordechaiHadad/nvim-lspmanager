local package_managers = {
    go = require("lspmanager.installers.go"),
    npm = require("lspmanager.installers.npm"),
    manual = require("lspmanager.installers.manual"),
    pip = require("lspmanager.installers.pip"),
}

return package_managers
