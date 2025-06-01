--------------------------------------------------------------------------------
--   DESCRIPTION: Character object
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Character : Object
local Character = Object:extend()

---@param status Status
---@return boolean
function Character:has_status(status)
    return HasStatusId(status)
end

---@param condition Condition|Condition[]
---@return boolean
function Character:has_condition(condition)
    return GetCharacterCondition(condition)
end

---@return Node
function Character:get_position()
    return Node(GetPlayerRawXPos(), GetPlayerRawYPos(), GetPlayerRawZPos())
end

---@return boolean
function Character:has_target()
    return GetTargetName() ~= ''
end

---@param target Targetable
function Character:wait_for_target(target)
    repeat
        target:target()
        Wait:seconds(0.5)
    until self:has_target()
end

---@return Node
function Character:get_target_position()
    return Node(GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos())
end

---@return boolean
function Character:is_moving()
    return IsMoving()
end

---@return boolean
function Character:is_not_moving()
    return IsMoving()
end

function Character:is_available()
    return IsPlayerAvailable()
end

function Character:is_not_available()
    return IsPlayerAvailable()
end

function Character:wait_until_available()
    Wait:seconds_until(self, self.is_available, 0.2)
end

function Character:wait_until_not_available()
    Wait:seconds_until(self, self.is_not_available, 0.2)
end

---Requires https://github.com/pohky/TeleporterPlugin
---@param destination string
function Character:teleport(destination)
    yield('/tp ' .. destination)
    self:wait_until_not_available(10)
    self:wait_until_available()
    Wait:seconds(2)
end

return Character()
