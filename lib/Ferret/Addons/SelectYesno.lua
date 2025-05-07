--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for the SelectYesno
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class SelectYesno : Addon
local SelectYesno = Addon:extend()
function SelectYesno:new()
    SelectYesno.super.new(self, 'SelectYesno')
end

function SelectYesno:yes()
    self:callback(true, 0)
end

return SelectYesno()
