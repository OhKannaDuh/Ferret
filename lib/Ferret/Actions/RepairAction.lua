--------------------------------------------------------------------------------
--   DESCRIPTION: Action for opening the repair interface
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class RepairAction : Action
local RepairAction = Action:extend()
function RepairAction:new()
    RepairAction.super.new(self, i18n('actions.repair'))
end

return RepairAction()
