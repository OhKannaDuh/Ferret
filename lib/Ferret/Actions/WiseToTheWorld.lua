--------------------------------------------------------------------------------
--   DESCRIPTION: Action for WiseToTheWorld
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class WiseToTheWorld : Action
local WiseToTheWorld = Action:extend()
function WiseToTheWorld:new()
    WiseToTheWorld.super.new(self, i18n('actions.wise_to_the_world'))
end

return WiseToTheWorld()
