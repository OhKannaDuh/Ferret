--------------------------------------------------------------------------------
--   DESCRIPTION: Object representing a Targetable object, such as a gathering
--                node or NPC
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Targetable : Object
---@field name string
Targetable = Object:extend()
function Targetable:new(name)
    self.name = name
end

---Target the subject if they are in range
function Targetable:target()
    yield('/target "' .. self.name .. '"')
end

---Tries to target the subject and interact with them
function Targetable:interact()
    self:target()
    Ferret:wait(0.2)
    yield('/interact')
end
