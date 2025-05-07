--------------------------------------------------------------------------------
--   DESCRIPTION: Helper class for file IO
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class IO : Object
local IO = Object:extend()

---Opens a file in the given path and mode
---@param path string
---@param mode string a|r|w
---@return file*?
function IO:open(path, mode)
    return io.open(path, mode)
end

---Checks if a file exists at the given class
---@param path string
---@return boolean
function IO:exists(path)
    local file = self:open(path, 'r')
    return file ~= nil
end

return IO()
