--------------------------------------------------------------------------------
--   DESCRIPTION: Action for SolidReason
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class SolidReason : Action
local SolidReason = Action:extend()
function SolidReason:new()
    SolidReason.super.new(self, i18n('actions.solid_reason'))
end

return SolidReason()
