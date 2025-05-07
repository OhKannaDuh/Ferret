--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for the Gathering window
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class GatheringAddon : Addon
local GatheringAddon = Addon:extend()

function GatheringAddon:new()
    GatheringAddon.super.new(self, 'Gathering')
end

function GatheringAddon:get_integrity()
    return self:get_node_number(33)
end

return GatheringAddon()
