--------------------------------------------------------------------------------
--   DESCRIPTION: Action for mounting a specified mount
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class MountAction : Action
local MountAction = Action:extend()
function MountAction:new()
    MountAction.super.new(self, i18n('actions.mount'))
end

function MountAction:execute(argument)
    Logger:debug_t('actions.messages.executing', { action = self.name })
    yield('/mount "' .. argument .. '"')
end

return MountAction()
