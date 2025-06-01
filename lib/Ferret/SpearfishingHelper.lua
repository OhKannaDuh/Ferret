--------------------------------------------------------------------------------
--   DESCRIPTION: SpearfishingHelper helper
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class SpearfishingHelper : Object
---@field last string
---@field caught table
local SpearfishingHelper = Object:extend()
function SpearfishingHelper:new()
    self.last = ''
    self.caught = {}
end

function SpearfishingHelper:is_spearfishing()
    return Addons.SpearFishing:is_ready()
end

function SpearfishingHelper:is_not_spearfishing()
    return not self:is_spearfishing()
end

function SpearfishingHelper:wait_to_start()
    Wait:seconds_until(self, self.is_spearfishing, 0.1)
end

function SpearfishingHelper:wait_to_stop()
    Wait:seconds_until(self, self.is_not_spearfishing, 0.1)
end

-- @todo Requires PR, after SND update
-- function SpearfishingHelper:get_wariness()
-- return GetNodeWidth('SpearFishing', 34, 3) / GetNodeWidth('SpearFishing', 34, 0)
-- end

function SpearfishingHelper:get_last_index()
    for index, entry in ipairs(Addons.SpearFishing:get_list()) do
        if (entry.name .. '-' .. entry.size) == self.last then
            return index
        end
    end

    return -1
end
