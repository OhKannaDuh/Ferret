--------------------------------------------------------------------------------
--   DESCRIPTION: CosmicExploration Mission Reward object
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class MissionReward : Object
---@field job Job
---@field tier integer
---@amount integer
MissionReward = Object:extend()

---@param job Job
---@param tier integer
---@param amount integer
function MissionReward:new(job, tier, amount)
    self.job = job
    self.tier = tier
    self.amount = amount
end
