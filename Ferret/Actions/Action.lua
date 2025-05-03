--------------------------------------------------------------------------------
--   DESCRIPTION: Abstract action class
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Action : Object, Translation
---@field name string
---@field is_ac_command boolean
Action = Object:extend()
---@param name string
function Action:new(name, is_ac_command)
    self.name = name
end

function Action:execute(argument)
    Logger:debug_t('actions.messages.executing', { action = self.name })
    yield('/ac "' .. self.name .. '"')
end
