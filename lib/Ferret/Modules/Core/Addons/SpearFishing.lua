--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for the
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class SpearFishing : Addon
local SpearFishing = Addon:extend()

function SpearFishing:new()
    SpearFishing.super.new(self, 'SpearFishing')
end

---@return table
function SpearFishing:get_latest()
    return {
        name = self:get_node_text(53, 3, 10),
        size = self:get_node_text(53, 3, 7),
    }
end

---@return table[]
function SpearFishing:get_list()
    return {
        {
            name = self:get_node_text(53, 3, 10),
            size = self:get_node_text(53, 3, 7),
        },
        {
            name = self:get_node_text(53, 4, 10),
            size = self:get_node_text(53, 4, 7),
        },
        {
            name = self:get_node_text(53, 5, 10),
            size = self:get_node_text(53, 3, 7),
        },
    }
end

return SpearFishing()
