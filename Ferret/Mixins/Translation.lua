--------------------------------------------------------------------------------
--   DESCRIPTION: This mixin is designed to make logging translations easier
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Translation : Object
---@field translation_path string
---@field log_info fun(string, table?)
---@field log_debug fun(string, table?)
---@field log_warn fun(string, table?)
---@field log_error fun(string, table?, boolean?)
Translation = Object:extend()
function Translation:new(translation_path)
    self.translation_path = translation_path
end

function Translation:build_key(key)
    return self.translation_path .. '.' .. key
end

function Translation:log_info(key, args, should_log)
    if not self.translation_path then
        Logger:warn('No translation_path set')
        Debug:log_previous_call()
        return
    end

    if should_log ~= nil and not should_log then
        return
    end

    Logger:info_t(self:build_key(key), args)
end

function Translation:log_debug(key, args, should_log)
    if not self.translation_path then
        Logger:warn('No translation_path set')
        Debug:log_previous_call()
        return
    end

    if should_log ~= nil and not should_log then
        return
    end

    Logger:debug_t(self:build_key(key), args)
end

function Translation:log_warn(key, args, should_log)
    if not self.translation_path then
        Logger:warn('No translation_path set')
        Debug:log_previous_call()
        return
    end

    if should_log ~= nil and not should_log then
        return
    end

    Logger:warn_t(self:build_key(key), args)
end

function Translation:log_error(key, args, show_backtrace, should_log)
    if not self.translation_path then
        Logger:warn('No translation_path set')
        Debug:log_previous_call()
        return
    end

    if should_log ~= nil and not should_log then
        return
    end

    Logger:error_t(self:build_key(key), args, show_backtrace)
end

function Translation:translate(key, args)
    return i18n(self:build_key(key), args)
end
