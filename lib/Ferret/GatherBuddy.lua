--------------------------------------------------------------------------------
--   DESCRIPTION: GatherBuddy helper
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class GatherBuddy : Object
local GatherBuddy = Object:extend()

---@param name string
function GatherBuddy:gather(name)
    yield('/gather ' .. name)
    Character:wait_until_not_available()
    Character:wait_until_available()
    Ferret:wait(2)
end

---@param name string
function GatherBuddy:gather_fish(name)
    yield('/gatherfish ' .. name)
    Character:wait_until_not_available()
    Character:wait_until_available()
    Ferret:wait(2)
end

return GatherBuddy()
