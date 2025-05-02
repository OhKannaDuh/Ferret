--------------------------------------------------------------------------------
--   DESCRIPTION: Managing events, a one to one callback system
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class EventManager : Object, Translation
---@field subscriptions table<Event, fun(table)>
---@field subscribe fun(Event, function)
local EventManager = Object:extend()
EventManager:implement(Translation)

function EventManager:new()
    self.subscriptions = {}
    self.translation_path = 'event_manager'
end

---@param event Event
---@param callback fun(table)
function EventManager:subscribe(event, callback)
    self:log_debug('subscribe', { event = Events.to_string(event) })
    self.subscriptions[event] = callback
end

---@param event Event
---@param context table?
function EventManager:emit(event, context)
    self:log_debug('emit', { event = Events.to_string(event) })
    if not self.subscriptions[event] then
        Logger:warn('NO EVENT ' .. event)
        return
    end

    self.subscriptions[event](context)
end

return EventManager()
