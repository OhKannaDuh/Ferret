--------------------------------------------------------------------------------
--   DESCRIPTION: A Debug helper class
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Debug : Object
---@field log_previous_call function
local Debug = Object:extend()

function Debug:log_previous_call()
    local info = debug.getinfo(3, 'Sln')

    Logger:debug_t('debug.previous_call', {
        filename = info.short_src:match('[^/\\]+$'),
        line = info.linedefined,
        method = info.name,
    })
end

function Debug:log_current_line()
    local info = debug.getinfo(2, 'Sln')

    Logger:debug_t('debug.current_line', {
        filename = info.short_src:match('[^/\\]+$'),
        line = info.linedefined,
        method = info.name,
    })
end

return Debug()
