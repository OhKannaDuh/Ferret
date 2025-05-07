--------------------------------------------------------------------------------
--   DESCRIPTION: Base Extension class
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Extension : Object, Translation
Extension = Object:extend()
Extension:implement(Translation)

---@param name string
---@param key string
function Extension:new(name, key)
    self.translation_path = 'extension.' .. key
    self.name = name
    self.key = key
end

function Extension:init()
    Logger:debug_t('extension.messages.no_init', { name = self })
end

function Extension:to_string()
    return self.name
end

function Extension:__tostring()
    return self:to_string()
end
