--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for the Gathering Masterpiece (Collectable)Gathering Masterpiece (Collectable)
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class GatheringMasterpiece : Addon
local GatheringMasterpiece = Addon:extend()

function GatheringMasterpiece:new()
    GatheringMasterpiece.super.new(self, 'GatheringMasterpiece')
end

function GatheringMasterpiece:get_collectablility()
    return self:get_node_number(140)
end

function GatheringMasterpiece:get_integrity()
    return self:get_node_number(61)
end

return GatheringMasterpiece()
