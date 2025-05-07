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

function SpearfishingHelper:wait_to_start()
    Ferret:wait_until(function()
        return self:is_spearfishing()
    end)
end

function SpearfishingHelper:wait_to_stop()
    Ferret:wait_until(function()
        return not self:is_spearfishing()
    end)
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
