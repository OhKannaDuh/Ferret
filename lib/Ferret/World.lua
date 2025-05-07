--------------------------------------------------------------------------------
--   DESCRIPTION: A class for interacting with the world
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class World : Object
local World = Object:extend()

---@return integer
function World:get_current_hour()
    return GetCurrentEorzeaHour()
end

--- Check if the current hour is between two supplied hours
---@param a integer
---@param b integer
function World:is_hour_between(a, b)
    local current = self:get_current_hour()
    if b < a then
        b = b + 24
    end

    return current >= a and current < b
end

function World:wait_until(hour)
    Logger:debug_t('world.waiting', { hour = hour })
    Ferret:wait_until(function()
        return self:get_current_hour() == hour
    end, 3)
    Logger:debug_t('world.done_waiting')
end

--- Checks the minimap for a special gathering node
---@return boolean
function World:has_special_node()
    return GetActiveMiniMapGatheringMarker() ~= nil
end

---@return Node?
function World:get_special_node()
    local marker = GetActiveMiniMapGatheringMarker()
    if marker == nil then
        return nil
    end

    local y = QueryMeshPointOnFloorY(marker[0], 1024, marker[1], false, 1)

    return Node(marker[0], y, marker[1])
end

---@param weather  Weather
---@return boolean
function World:is_weather(weather)
    return GetActiveWeatherID() == weather
end

return World()
