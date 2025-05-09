--------------------------------------------------------------------------------
--   DESCRIPTION: WKSToolCustomize addon, window with relic levels and exp
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class WKSToolCustomize : Addon
local WKSToolCustomize = Addon:extend()
WKSToolCustomize:implement(AddonMixins.GracefulOpen, AddonMixins.GracefulClose)

function WKSToolCustomize:new()
    WKSToolCustomize.super.new(self, 'WKSToolCustomize')
end

function WKSToolCustomize:open()
    Addons.WKSHud:open_cosmic_research()
end

function WKSToolCustomize:close()
    Addons.WKSHud:close_cosmic_research()
end

function WKSToolCustomize:get_progress()
    return {
        self:get_exp(2),
        self:get_exp(3),
        self:get_exp(4),
        self:get_exp(5),
    }
end

function WKSToolCustomize:get_exp(index)
    return ResearchProgressBar(
        self:get_node_number(8, index, 6) or 0,
        self:get_node_number(8, index, 4) or 0,
        self:get_node_number(8, index, 2) or 0
    )
end

function WKSToolCustomize:get_exp_1()
    return self:get_exp(2)
end

function WKSToolCustomize:get_exp_2()
    return self:get_exp(3)
end

function WKSToolCustomize:get_exp_3()
    return self:get_exp(4)
end

function WKSToolCustomize:get_exp_4()
    return self:get_exp(5)
end

function WKSToolCustomize:get_relic_ranks()
    local ranks = {}
    for index = 2, 12 do
        ranks[index + 6] = self:get_node_number(28, index, 5)
    end

    return ranks
end

return WKSToolCustomize()
