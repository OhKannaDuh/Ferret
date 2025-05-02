--------------------------------------------------------------------------------
--   DESCRIPTION: Main library class
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

require('Ferret/Library')

---@class Ferret : Object, Translation
---@field name string
---@field run boolean
---@field language string en/de/fr/jp
---@field plugins Plugin[]
---@field timer Timer
Ferret = Object:extend()
Ferret:implement(Translation)

function Ferret:new(name)
    self.name = name
    self.run = true
    self.language = 'en'
    self.plugins = {}
    self.timer = Timer()
    self.version = Version(0, 11, 4)

    self.translation_path = 'ferret'

    self:register_default_events()
end

---@param plugin Plugin
function Ferret:add_plugin(plugin)
    self:log_debug('adding_plugin', { plugin = plugin.name })
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

    self:log_debug('running_setup')
    if not self:setup() then
        self:log_error('setup_error')
        return
    end

    self:log_debug('starting_loop')
    while self.run do
        HookManager:emit(Hooks.PRE_LOOP)
        self:loop()
        if self.run then
            HookManager:emit(Hooks.POST_LOOP)
        end
    end
end

function Ferret:register_default_events()
    EventManager:subscribe(Events.STOP_CRAFT, function(context)
        self:log_debug('events.default_message', { event = Events.to_string(Events.STOP_CRAFT) })

        if Addons.Synthesis:graceful_close() then
            Addons.RecipeNote:wait_until_ready()
        end

        Addons.RecipeNote:graceful_close()

        Character:wait_until_available()
    end)

    EventManager:subscribe(Events.PREPARE_TO_CRAFT, function(context)
        self:log_debug('events.default_message', { event = Events.to_string(Events.PREPARE_TO_CRAFT) })

        Character:wait_until_available()
        Addons.RecipeNote:graceful_open()
    end)
end
