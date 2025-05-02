--------------------------------------------------------------------------------
--   DESCRIPTION: Abstract addon class
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Addon : Object
---@field key string
Addon = Object:extend()

---@param key string
function Addon:new(key)
    self.key = key

    self.ready_delay = 1 / 60
    self.ready_max = nil
    self.not_ready_delay = 1 / 60
    self.not_ready_max = nil
    self.visible_delay = 1 / 60
    self.visible_max = nil
    self.not_visible_delay = 1 / 60
    self.not_visible_max = nil
end

---@return boolean
function Addon:is_ready()
    return IsAddonReady(self.key)
end

function Addon:wait_until_ready(delay, max)
    delay = delay or self.ready_delay
    max = max or self.ready_max

    Logger:debug_t('addons.messages.wait_until_ready', { addon = self.key })
    Debug:log_previous_call()

    Ferret:wait_until(function()
        return self:is_ready()
    end, delay, max)

    Logger:debug_t('addons.messages.ready', { addon = self.key })
end

function Addon:wait_until_not_ready(delay, max)
    delay = delay or self.not_ready_delay
    max = max or self.not_ready_max

    Logger:debug_t('addons.messages.wait_until_not_ready', { addon = self.key })
    Debug:log_previous_call()

    Ferret:wait_until(function()
        return not self:is_ready()
    end, delay, max)

    Logger:debug_t('addons.messages.not_ready', { addon = self.key })
end

---@return boolean
function Addon:is_visible()
    return IsAddonVisible(self.key)
end

function Addon:wait_until_visible(delay, max)
    delay = delay or self.visible_delay
    max = max or self.visible_max

    Logger:debug_t('addons.messages.wait_until_visible', { addon = self.key })
    Debug:log_previous_call()
    Ferret:wait_until(function()
        return self:is_visible()
    end, delay, max)

    Logger:debug_t('addons.messages.visible', { addon = self.key })
end

function Addon:wait_until_not_visible(delay, max)
    delay = delay or self.not_visible_delay
    max = max or self.not_visible_max

    Logger:debug_t('addons.messages.wait_until_not_visible', { addon = self.key })
    Debug:log_previous_call()
    Ferret:wait_until(function()
        return not self:is_ready()
    end, delay, max)

    Logger:debug_t('addons.messages.not_visible', { addon = self.key })
end

---@param ... integer
---@return string
function Addon:get_node_text(...)
    Ferret:wait(0.0167)
    return GetNodeText(self.key, ...)
end

---@param ... integer
---@return integer
function Addon:get_node_number(...)
    return String:parse_number(self:get_node_text(...))
end

---@param ... integer
---@return boolean
function Addon:is_node_visible(...)
    Ferret:wait(0.0167)
    return IsNodeVisible(self.key, ...)
end

---@param update_visiblity boolean
---@param ... integer
function Addon:callback(update_visiblity, ...)
    local command = self.key
    if update_visiblity then
        command = command .. ' true'
    else
        command = command .. ' false'
    end
    for k, v in ipairs({ ... }) do
        command = command .. ' ' .. v
    end

    Logger:debug_t('addons.messages.callback', { command = command })
    Debug:log_previous_call()

    yield('/callback ' .. command)
end
