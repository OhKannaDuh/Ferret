--------------------------------------------------------------------------------
--   DESCRIPTION: Represetnts mission score current/silver/gold
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class MissionScore : Object
---@field tier MissionResult
---@field current integer
---@field next integer
MissionScore = Object:extend()
---@param tier MissionResult
---@param current integer
---@param next integer
function MissionScore:new(tier, current, next)
    self.tier = tier
    self.current = current
    self.next = next
end

function MissionScore:to_string()
    return string.format('Tier: %s, Current: %d, Next: %d', MissionResult.to_string(self.tier), self.current, self.next)
end

function MissionScore:__tostring()
    return self:to_string()
end
