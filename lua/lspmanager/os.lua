local os = {}
local luv = require"luv"

os.OSes = {
    Nothing = 0,
    Windows = 1,
    Unix = 2
}

local current_os = os.OSes.Nothing

if luv.os_uname().sysname == "Windows_NT" then
    current_os = os.OSes.Windows
else
    current_os = os.OSes.Unix
end

os.get_os = function ()
    return current_os
end

return os
