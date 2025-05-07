--------------------------------------------------------------------------------
--   DESCRIPTION: Mount helper
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Mount : Object
---@field name string
local Mount = Object:extend()
function Mount:new()
    self.name = nil
end

---@return boolean
function Mount:is_mounted()
    return Character:has_condition(Conditions.Mounted)
end

---@return boolean
function Mount:is_mounting()
    return Character:has_condition(Conditions.Mounting)
end

---@return boolean
function Mount:is_flying()
    return Character:has_condition(Conditions.Flying)
end

function Mount:roulette()
    Ferret:repeat_until(function()
        Actions.MountRoulette:execute()
    end, function()
        return self:is_mounted()
    end)
end

---@param name string?
function Mount:mount(name)
    name = name or self.name
    if name == nil then
        return self:roulette()
    end

    Actions.Mount:execute(name)
end

function Mount:unmount()
    Ferret:repeat_until(function()
        Actions.Mount:execute()
    end, function()
        return not self:is_flying() and not self:is_mounted()
    end)
end

function Mount:land()
    Ferret:repeat_until(function()
        Actions.Mount:execute()
    end, function()
        return not self:is_flying()
    end, 2)

    -- This function is a bit bugged, sometimes it will unmount you
    -- This call remounts you if you get unmounted
    if not self:is_mounted() then
        self:mount()
    end
end

return Mount()
