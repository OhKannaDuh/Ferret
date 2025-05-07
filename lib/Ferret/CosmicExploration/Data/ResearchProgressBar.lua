--------------------------------------------------------------------------------
--   DESCRIPTION: Represents cosmic relic research/exp bars
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class ResearchProgressBar : Object
---@field current integer
---@field required integer
---@field max integer
ResearchProgressBar = Object:extend()

---@param current integer
---@param required integer
---@param max integer
function ResearchProgressBar:new(current, required, max)
    self.current = current
    self.required = required
    self.max = max
end
