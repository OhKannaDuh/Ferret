--------------------------------------------------------------------------------
--   DESCRIPTION: A collection of string helpers
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class String : Object
local String = Object:extend()

---@param subject string
---@param prefix string
function String:starts_with(subject, prefix)
    return string.sub(subject, 1, string.len(prefix)) == prefix
end

---@param subject string|number
---@return number?
function String:parse_number(subject)
    if type(subject) == 'number' then
        return subject
    end

    return tonumber((subject:gsub(',', ''):gsub('%.', ''):gsub(' ', '')))
end

return String()
