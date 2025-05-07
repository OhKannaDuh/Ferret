--------------------------------------------------------------------------------
--   DESCRIPTION: Cosmic exploration recipe selection addon
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class WKSRecipeNotebook : Addon
local WKSRecipeNotebook = Addon:extend()
WKSRecipeNotebook:implement(AddonMixins.GracefulClose)

function WKSRecipeNotebook:new()
    WKSRecipeNotebook.super.new(self, 'WKSRecipeNotebook')
end

function WKSRecipeNotebook:set_index(index)
    self:wait_until_ready()
    self:callback(true, 0, index)
end

function WKSRecipeNotebook:set_hq()
    self:wait_until_ready()
    self:callback(true, 5)
end

function WKSRecipeNotebook:synthesize()
    self:callback(true, 6)
end

function WKSRecipeNotebook:graceful_synthesize()
    self:wait_until_ready()
    repeat
        self:synthesize()
        Wait:fps(5)
    until not WKSRecipeNotebook:is_visible()
end

function WKSRecipeNotebook:get_current_recipe_name()
    return self:get_node_text(38)
end

function WKSRecipeNotebook:get_current_craftable_amount()
    return self:get_node_number(24)
end

function WKSRecipeNotebook:open()
    Addons.WKSMissionInfomation:open_craftinglog()
end

function WKSRecipeNotebook:graceful_open()
    if self:is_ready() or Addons.WKSMission:is_ready() then
        return false
    end

    return Addons.WKSMissionInfomation:graceful_open_craftinglog()
end

return WKSRecipeNotebook()
