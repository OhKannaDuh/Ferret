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
    repeat
        Actions.MountRoulette:execute()
        Wait:seconds(0.5)
    until self:is_mounted()
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
    repeat
        Actions.Mount:execute()
        Wait:seconds(0.5)
    until  not self:is_flying() and not self:is_mounted()
end

function Mount:land()
    repeat
        Actions.Mount:execute()
        Wait:seconds(3)
    until not self:is_flying()

    -- This function is a bit bugged, sometimes it will unmount you
    -- This call remounts you if you get unmounted
    if not self:is_mounted() then
        self:mount()
    end
end

return Mount()
