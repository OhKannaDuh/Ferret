--------------------------------------------------------------------------------
--   DESCRIPTION: Action for MeticulousWoodsman
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class MeticulousWoodsman : Action
local MeticulousWoodsman = Action:extend()
function MeticulousWoodsman:new()
    MeticulousWoodsman.super.new(self, i18n('actions.meticulous_woodsman'))
end

return MeticulousWoodsman()
