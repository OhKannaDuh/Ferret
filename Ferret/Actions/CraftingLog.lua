--------------------------------------------------------------------------------
--   DESCRIPTION: Action for opening the crafting log / Recipenote
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class CraftingLog : Action
local CraftingLog = Action:extend()
function CraftingLog:new()
    CraftingLog.super.new(self, i18n('actions.crafting_log'))
end

function CraftingLog:execute(argument)
    Logger:debug_t('actions.messages.executing', { action = self.name })
    yield('/' .. self.name)
    -- Wait:milliseconds(500)
end

return CraftingLog()
