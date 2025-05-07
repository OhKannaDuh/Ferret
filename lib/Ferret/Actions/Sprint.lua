--------------------------------------------------------------------------------
--   DESCRIPTION: Action for sprinting
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Sprint : Action
local Sprint = Action:extend()
function Sprint:new()
    Sprint.super.new(self, i18n('actions.sprint'))
end

return Sprint()
