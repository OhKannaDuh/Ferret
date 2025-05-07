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
    Ferret:repeat_until(function()
        target:target()
    end, function()
        return self:has_target()
    end)
end

---@return Node
function Character:get_target_position()
    return Node(GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos())
end

---@return boolean
function Character:is_moving()
    return IsMoving()
end

function Character:is_available()
    return IsPlayerAvailable()
end

function Character:wait_until_available()
    Ferret:wait_until(function()
        return self:is_available()
    end, 0.2)
end

function Character:wait_until_not_available()
    Ferret:wait_until(function()
        return not self:is_available()
    end, 0.2)
end

---Requires https://github.com/pohky/TeleporterPlugin
---@param destination string
function Character:teleport(destination)
    yield('/tp ' .. destination)
    self:wait_until_not_available(10)
    self:wait_until_available()
    Ferret:wait(2)
end

--- Wait in 0.1 second intervals until the character is not crafting and not
--- preparing to craft
function Character:wait_until_done_crafting()
    Ferret:wait_until(function()
        return not self:has_condition(Conditions.Crafting40) and not self:has_condition(Conditions.PreparingToCraft)
    end, 0.1)
end

return Character()
