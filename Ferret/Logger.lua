--------------------------------------------------------------------------------
--   DESCRIPTION: A text logger
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Logger : Object
---@field log_file_directory string|nil A directory path where files should be stored. If this is defined then logs will also be logged in files.
---@filed log_file_name string|nil
---@field file_only boolean Prevents echoing logs when false
---@field show_debug boolean Allows debug logs to be logged
local Logger = Object:extend()
function Logger:new()
    self.log_file_directory = nil
    self.log_file_name = _log_name
    self.file_only = false
    self.show_debug = _debug or false
end

function Logger:init()
    if _log_directory then
        self:set_log_file_directory(_log_directory)
    end
end

---Sets log_file_directory, copies the current log to [name].prev.log and prepares [name].log
---@param directory string The path
function Logger:set_log_file_directory(directory)
    self.log_file_directory = directory
    local path = self.log_file_directory .. '/' .. self:get_log_file_name() .. '.log'
    local prev_path = path:gsub('%.log', '.prev.log')

    local file = IO:open(path)

    if file ~= nil then
        file:close()
        file = IO:open(path, 'r')
        IO:open(prev_path, 'w'):write(file:read('*all')):close()
    end

    if file then
        file:close()
    end

    IO:open(path, 'w'):write(''):close()
end

---Logs whatever message is given to its
---@param ... string The message to log
function Logger:log(...)
    local args = { ... }
    local count = Table:count(args)
    if count == 0 then
        return
    end

    local message = tostring(args[count])
    local prefix = {}
    for i = 1, count - 1 do
        table.insert(prefix, tostring(args[i]))
    end

    local prefix = self:build_prefix(prefix)
    local full_message = prefix .. ': ' .. message

    if self.log_file_directory ~= nil then
        local path = self.log_file_directory .. '/' .. self:get_log_file_name() .. '.log'
        local log_message = '[' .. os.date('%H:%M:%S') .. ']' .. full_message

        local file = IO:open(path, 'a')
        if file then
            file:write(log_message .. '\n'):close()
        end
    end

    if not self.file_only then
        LogInfo(full_message)
    end
end

---Logs the type of the given variable
---@param subject any
function Logger:type(subject)
    if not self.show_debug then
        return
    end

    self:log('Debug', 'Type', type(subject))
end

---Logs the given table
---@param subject table
function Logger:table(subject)
    self:log('Debug', 'Table', Table:dump(subject))
end

---Logs the given table
---@param subject table
function Logger:keys(subject)
    self:log('Debug', 'Keys', Table:keys(subject))
end

function Logger:list(identifier, subject)
    self:log('List', identifier, 'Start', '')
    for _, value in ipairs(subject) do
        self:log('List', identifier, 'Child', tostring(value))
    end

    self:log('List', identifier, 'End', '')
end

function Logger:info_t(key, args)
    self:info(i18n(key, args))
end

---Logs under the info level.
---@param contents string Data to log or translation string
function Logger:info(contents)
    contents = contents or ''

    self:log('Info', contents or '')
end

function Logger:debug_t(key, args)
    self:debug(i18n(key, args))
end

---Logs under the debug level. Logs are only logged when show_debug is true
---@param contents string Data to log or translation string
function Logger:debug(contents)
    if not self.show_debug then
        return
    end

    self:log('Debug', contents or '')
end

function Logger:warn_t(key, args)
    self:warn(i18n(key, args))
end

---Logs under the warn level.
---@param contents string Data to log or translation string
function Logger:warn(contents)
    self:log('Warn', contents or '')
end

function Logger:error_t(key, args, show_backtrace)
    self:error(i18n(key, args), show_backtrace)
end

---Logs under the error level. Checks if given contents is a translation string
---@param contents string Data to log or translation string
---@param show_backtrace? boolean Prints the current backtrace if not supplied or true, pass false to prevent this
function Logger:error(contents, show_backtrace)
    self:log('Error', contents or '')

    if show_backtrace or show_backtrace == nil then
        self:log('Backtrace', debug.traceback())
    end
end

function Logger:build_prefix(...)
    local name = 'No Context'
    if Ferret and Ferret.name then
        name = Ferret.name
    end

    local prefix = '[' .. name .. ']'

    for _, arg in ipairs(...) do
        prefix = prefix .. '[' .. tostring(arg) .. ']'
    end

    return prefix
end

function Logger:get_log_file_name()
    if Ferret and Ferret.name then
        return Ferret.name
    end

    return self.log_file_name or 'No Context'
end

return Logger()
