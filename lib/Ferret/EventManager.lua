--------------------------------------------------------------------------------
--   DESCRIPTION: Managing Events, a one to many callback system
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class EventManager : Object, Translation
---@field subscriptions table<Event, fun(table)[]>
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
    if not self.subscriptions[event] then
        self.subscriptions[event] = {}
    end

    table.insert(self.subscriptions[event], callback)
end

---@param event Event
---@param context table?
function EventManager:emit(event, context)
    self:log_debug('emit', { event = Events.to_string(event) })
    if not self.subscriptions[event] then
        return
    end

    for _, callback in pairs(self.subscriptions[event]) do
        callback(context)
    end
end

return EventManager()
