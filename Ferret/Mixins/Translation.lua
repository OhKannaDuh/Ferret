--------------------------------------------------------------------------------
--   DESCRIPTION: This mixin is designed to make logging translations easier
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Translation : Object
---@field log_info fun(string, table?)
---@field log_debug fun(string, table?)
---@field log_warn fun(string, table?)
---@field log_error fun(string, table?, boolean?)
Translation = Object:extend()
function Translation:new()
    self.translation_path = nil
end

function Translation:build_key(key)
    return self.translation_path .. '.' .. key
end

function Translation:log_info(key, args)
    if not self.translation_path then
        Logger:warn('No translation_path set')
        Debug:log_previous_call()
        return
    end

    Logger:info_t(self:build_key(key), args)
end

function Translation:log_debug(key, args)
    if not self.translation_path then
        Logger:warn('No translation_path set')
        Debug:log_previous_call()
        return
    end

    Logger:debug_t(self:build_key(key), args)
end

function Translation:log_warn(key, args)
    if not self.translation_path then
        Logger:warn('No translation_path set')
        Debug:log_previous_call()
        return
    end

    Logger:warn_t(self:build_key(key), args)
end

function Translation:log_error(key, args, show_backtrace)
    if not self.translation_path then
        Logger:warn('No translation_path set')
        Debug:log_previous_call()
        return
    end

    Logger:error_t(self:build_key(key), args, show_backtrace)
end

function Translation:translate(key, args)
    return i18n(self:build_key(key), args)
end
