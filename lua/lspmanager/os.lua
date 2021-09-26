local os = {}
local uv = vim.loop

os.OSes = {
    Nothing = 0,
    Windows = 1,
    Unix = 2,
    MacOS = 3,
}

local current_os = os.OSes.Nothing
local fetched_os = uv.os_uname().sysname
if fetched_os == "Windows_NT" then
    current_os = os.OSes.Windows
elseif fetched_os == "Darwin" then
    current_os = os.OSes.MacOS
else
    current_os = os.OSes.Unix
end

os.get_os = function()
    return current_os
end

return os
