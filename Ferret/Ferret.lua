--------------------------------------------------------------------------------
--   DESCRIPTION: Main library class
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

require('Ferret/Library')

---@class Ferret : Object
---@field name string
---@field run boolean
---@field language string en/de/fr/jp
---@field plugins Plugin[]
---@field hook_subscriptions table<Hook, fun(table)[]>
---@field timer Timer
Ferret = Object:extend()
function Ferret:new(name)
    self.name = name
    self.run = true
    self.language = 'en'
    self.plugins = {}
    self.hook_subscriptions = {}
    self.timer = Timer()
    self.version = Version(0, 11, 3)
end

---@param plugin Plugin
function Ferret:add_plugin(plugin)
    Logger:debug_t('Adding plugin: ' .. plugin.name)
    plugin:init(self)
    self.plugins[plugin.key] = plugin
end

---@param interval number
function Ferret:wait(interval)
    yield('/wait ' .. interval)
end

---@param action function
---@param condition fun(): boolean
---@param delay? number
---@param max? number
function Ferret:repeat_until(action, condition, delay, max)
    local delay = delay or 0.5
    local elapsed = 0

    local last_return = nil

    repeat
        last_return = action()
        self:wait(delay)
        elapsed = elapsed + delay
    until condition() or (max ~= nil and max > 0 and elapsed >= max)

    return last_return
end

---@param condition fun(): boolean
---@param delay? number
---@param max? number
function Ferret:wait_until(condition, delay, max)
    local delay = delay or 0.5
    local elapsed = 0

    if condition() then
        return
    end

    repeat
        self:wait(delay)
        elapsed = elapsed + delay
    until condition() or (max ~= nil and max > 0 and elapsed >= max)
end

---Stops the loop from running
function Ferret:stop()
    Logger:debug_t('ferret.stopping')
    self.run = false
end

---Base setup function
function Ferret:setup()
    Logger:warn_t('ferret.no_setup')
end

---Base loop function
function Ferret:loop()
    Logger:warn_t('ferret.no_loop')
    self:stop()
end

---Starts the loop
function Ferret:start()
    self.timer:start()
    Logger:info_t('version', { name = 'Ferret', version = self.version:to_string() })

    Logger:debug_t('ferret.running_setup')
    if not self:setup() then
        Logger:error_t('ferret.setup_error')
        return
    end

    Logger:debug_t('ferret.starting_loop')
    while self.run do
        self:emit(Hooks.PRE_LOOP)
        self:loop()
        if self.run then
            self:emit(Hooks.POST_LOOP)
        end
    end
end

---@param hook Hook
---@param callback fun(table)
function Ferret:subscribe(hook, callback)
    Logger:debug_t('ferret.hook_subscription', { hook = hook })
    if not self.hook_subscriptions[hook] then
        self.hook_subscriptions[hook] = {}
    end

    table.insert(self.hook_subscriptions[hook], callback)
end

---@param event Hook
---@param context table?
function Ferret:emit(event, context)
    Logger:debug_t('ferret.emit_event', { event = event })
    if not self.hook_subscriptions[event] then
        return
    end

    for _, callback in pairs(self.hook_subscriptions[event]) do
        callback(context)
    end
end

---@param name string
function Ferret:action(name)
    yield('/ac "' .. name .. '"')
end

---@param addon Addon
---@param update_visiblity boolean
---@param ... integer
function Ferret:callback(addon, update_visiblity, ...)
    local command = '/callback ' .. addon.key
    if update_visiblity then
        command = command .. ' true'
    else
        command = command .. ' false'
    end
    for k, v in ipairs({ ... }) do
        command = command .. ' ' .. v
    end

    Logger:debug_t('ferret.callback', { command = command })
    yield(command)
end
