--------------------------------------------------------------------------------
--   DESCRIPTION: Wait helper
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Wait : Object
local Wait = Object:extend()

function Wait:seconds(seconds)
    yield('/wait ' .. seconds)
end

function Wait:seconds_until(condition_object, condition, seconds)
    if condition(condition_object) then
        return
    end

    repeat
        self:seconds(seconds)
    until condition(condition_object)
end

function Wait:milliseconds(miliseconds)
    self:seconds(miliseconds / 1000)
end

function Wait:miliseconds_until(condition_object, condition, miliseconds)
    if condition(condition_object) then
        return
    end

    repeat
        self:seconds(miliseconds)
    until condition(condition_object)
end

function Wait:tps(target)
    self:seconds(1 / target)
end

function Wait:tps_until(condition_object, condition, tps)
    if condition(condition_object) then
        return
    end

    repeat
        self:tps(tps)
    until condition(condition_object)
end

function Wait:fps(target)
    self:tps(target)
end

function Wait:fps_until(condition_object, condition, fps)
    self:tps_until(condition_object, condition, fps)
end

return Wait()
