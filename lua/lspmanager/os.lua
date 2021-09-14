local os = {}
local uv = vim.loop

os.OSes = {
    Nothing = 0,
    Windows = 1,
    Unix = 2,
}

local current_os = os.OSes.Nothing

if uv.os_uname().sysname == "Windows_NT" then
    current_os = os.OSes.Windows
else
    current_os = os.OSes.Unix
end

os.get_os = function()
    return current_os
end

return os
