--------------------------------------------------------------------------------
--   DESCRIPTION: Action for opening the Aetherial Reduction interface
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class AetherialReduction : Action
local AetherialReduction = Action:extend()
function AetherialReduction:new()
    AetherialReduction.super.new(self, i18n('actions.aetherial_reduction'))
end

return AetherialReduction()
