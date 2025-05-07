--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for the SelectIconString
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class SelectIconString : Addon
local SelectIconString = Addon:extend()
function SelectIconString:new()
    SelectIconString.super.new(self, 'SelectIconString')
end

function SelectIconString:select_index(index)
    self:callback(true, index)
end

return SelectIconString()
