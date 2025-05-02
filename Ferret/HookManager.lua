--------------------------------------------------------------------------------
--   DESCRIPTION: Managing hooks, a one to many callback system
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class HookManager : Object, Translation
---@field subscriptions table<Hook, fun(table)[]>
local HookManager = Object:extend()
HookManager:implement(Translation)

function HookManager:new()
    self.subscriptions = {}
    self.translation_path = 'hook_manager'
end

---@param hook Hook
---@param callback fun(table)
function HookManager:subscribe(hook, callback)
    self:log_debug('subscribe', { hook = hook })
    if not self.subscriptions[hook] then
        self.subscriptions[hook] = {}
    end

    table.insert(self.subscriptions[hook], callback)
end

---@param hook Hook
---@param context table?
function HookManager:emit(hook, context)
    self:log_debug('emit', { hook = hook })
    if not self.subscriptions[hook] then
        return
    end

    for _, callback in pairs(self.subscriptions[hook]) do
        callback(context)
    end
end

return HookManager()
