--------------------------------------------------------------------------------
--   DESCRIPTION: A collection of table helpers
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Table : Object
local Table = Object:extend()

---@param subject table
---@return integer
function Table:count(subject)
    local count = 0

    for _ in pairs(subject) do
        count = count + 1
    end

    return count
end

---@param subject table
---@param search any
---@return boolean
function Table:contains(subject, search)
    for _, v in pairs(subject) do
        if v == search then
            return true
        end
    end
    return false
end

---@generic T : any
---@param subject T[]
---@return T|nil
function Table:random(subject)
    if Table:is_empty(subject) then
        return nil
    end

    local keys = {}
    for key, _ in pairs(subject) do
        table.insert(keys, key)
    end

    local key = keys[math.random(1, #keys)]
    return subject[key]
end

---@generic T : any
---@param subject T[]
---@return T|nil
function Table:first(subject)
    for _, value in pairs(subject) do
        return value
    end

    return nil
end

---@param subject table
---@return string
function Table:dump(subject)
    if type(subject) == 'table' then
        local s = '{ '
        for k, v in pairs(subject) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. '[' .. k .. '] = ' .. self:dump(v) .. ','
        end
        return s .. '} '
    end

    return tostring(subject)
end

---@param subject table
---@return boolean
function Table:is_empty(subject)
    for _, _ in pairs(subject) do
        return false
    end

    return true
end

---@param subject table
---@return string
function Table:keys(subject)
    local keys = {}
    for key, _ in pairs(subject) do
        table.insert(keys, tostring(key))
    end

    return table.concat(keys, ', ')
end

return Table()
