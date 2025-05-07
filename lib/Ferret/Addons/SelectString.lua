--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for the SelectString
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class SelectString : Addon
local SelectString = Addon:extend()
function SelectString:new()
    SelectString.super.new(self, 'SelectString')
end

function SelectString:select_index(index)
    self:callback(true, index)
end

return SelectString()
