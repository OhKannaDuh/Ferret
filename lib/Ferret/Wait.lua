--------------------------------------------------------------------------------
--   DESCRIPTION: Wait helper
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Wait : Object
local Wait = Object:extend()

function Wait:seconds(seconds)
    yield('/wait ' .. seconds)
end

function Wait:seconds_until(condition_object, condition, seconds, max)
    if condition(condition_object) then
        return
    end

    max = max or math.huge
    local elapsed = 0

    repeat
        self:seconds(seconds)
        elapsed = elapsed + seconds
    until condition(condition_object) or elapsed >= max
end

function Wait:milliseconds(miliseconds)
    self:seconds(miliseconds / 1000)
end

function Wait:miliseconds_until(condition_object, condition, miliseconds, max)
    if condition(condition_object) then
        return
    end

    max = max or math.huge
    local elapsed = 0

    repeat
        self:seconds(miliseconds)
        elapsed = elapsed + (miliseconds / 1000)
    until condition(condition_object) or elapsed >= max
end

function Wait:tps(target)
    self:seconds(1 / target)
end

function Wait:tps_until(condition_object, condition, tps, max)
    if condition(condition_object) then
        return
    end

    max = max or math.huge
    local elapsed = 0

    repeat
        self:tps(tps)
        elapsed = elapsed + (1 / tps)
    until condition(condition_object) or elapsed >= max
end

function Wait:fps(target)
    self:tps(target)
end

function Wait:fps_until(condition_object, condition, fps, max)
    self:tps_until(condition_object, condition, fps, max)
end

return Wait()
