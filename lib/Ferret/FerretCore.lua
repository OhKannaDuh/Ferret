--------------------------------------------------------------------------------
--   DESCRIPTION: Main library class
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

require('Ferret/Library')

---@class FerretCore : Object, Translation
---@field name string
---@field run boolean
---@field language string en/de/fr/jp
---@field timer Timer
FerretCore = Object:extend()
FerretCore:implement(Translation)

function FerretCore:new(name)
    self.translation_path = 'ferret'

    self.name = _name or name or 'Ferret'
    self.run = true
    self.language = 'en'
    self.timer = Timer()
    self.version = Version(0, 12, 1)
end

function FerretCore:init()
    Ferret = self

    Logger:init()

    Logger:info_t('version', { name = 'Ferret', version = self.version })

    self:register_default_events()
end

---@deprecated
---@param interval number
function FerretCore:wait(interval)
    yield('/wait ' .. interval)
end

---@param action function
---@param condition fun(): boolean
---@param delay? number
---@param max? number
function FerretCore:repeat_until(action, condition, delay, max)
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
function FerretCore:wait_until(condition, delay, max)
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
function FerretCore:stop()
    Logger:debug_t('ferret.stopping')
    self.run = false
end

---Base setup function
function FerretCore:setup()
    Logger:warn_t('ferret.no_setup')
end

---Base loop function
function FerretCore:loop()
    Logger:warn_t('ferret.no_loop')
    self:stop()
end

---Starts the loop
function FerretCore:start()
    self.timer:start()

    Logger:debug_t('ferret.running_setup')
    if not self:setup() then
        self:log_error('setup_error')
        return
    end

    Logger:debug_t('ferret.starting_loop')
    while self.run do
        EventManager:emit(Events.PRE_LOOP)

        self:loop()

        if self.run then
            EventManager:emit(Events.POST_LOOP)
        end
    end
end

function FerretCore:register_default_events()
    Logger:debug_t('ferret.requests.registering_callbacks')
    RequestManager:subscribe(Requests.STOP_CRAFT, function(context)
        Logger:debug_t('ferret.requests.default_message', { request = Requests.to_string(Requests.STOP_CRAFT) })

        if Addons.Synthesis:graceful_close() then
            Addons.RecipeNote:wait_until_ready()
        end

        Addons.RecipeNote:graceful_close()

        Character:wait_until_available()
    end)

    RequestManager:subscribe(Requests.PREPARE_TO_CRAFT, function(context)
        Logger:debug_t('ferret.requests.default_message', { request = Requests.to_string(Requests.PREPARE_TO_CRAFT) })

        Character:wait_until_available()
        Addons.RecipeNote:graceful_open()
    end)
end
