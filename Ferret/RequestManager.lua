--------------------------------------------------------------------------------
--   DESCRIPTION: Managing requests, a one to one callback system
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class RequestManager : Object, Translation
---@field subscriptions table<Request, fun(table)>
---@field subscribe fun(Request, function)
local RequestManager = Object:extend()
RequestManager:implement(Translation)

function RequestManager:new()
    self.subscriptions = {}
    self.translation_path = 'request_manager'
end

---@param request Request
---@param callback fun(table)
function RequestManager:subscribe(request, callback)
    self:log_debug('subscribe', { request = Requests.to_string(request) })
    self.subscriptions[request] = callback
end

---@param request Request
---@param context table?
function RequestManager:request(request, context)
    self:log_debug('emit', { request = Requests.to_string(request) })
    if not self.subscriptions[request] then
        Logger:warn('NO EVENT ' .. request)
        return
    end

    self.subscriptions[request](context)
end

return RequestManager()
