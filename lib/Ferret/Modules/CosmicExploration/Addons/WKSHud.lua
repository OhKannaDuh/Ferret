--------------------------------------------------------------------------------
--   DESCRIPTION: Main Cosmic Exploration hud
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class WKSHud : Addon
local WKSHud = Addon:extend()
function WKSHud:new()
    WKSHud.super.new(self, 'WKSHud')
end

function WKSHud:open_mission_menu()
    -- if Addons.WKSMission:is_visible() or Addons.WKSMissionInfomation:is_visible() then
    --     return
    -- end

    self:callback(true, 11)
end

function WKSHud:open_cosmic_research()
    if Addons.WKSToolCustomize:is_visible() then
        return
    end

    self:callback(true, 15)
end

function WKSHud:close_cosmic_research()
    if not Addons.WKSToolCustomize:is_visible() then
        return
    end

    self:callback(true, 15)
end

function WKSHud:get_cosmic_credits()
    if not self:is_ready() then
        return 0
    end

    return self:get_node_number(5, 3)
end

function WKSHud:get_lunar_credits()
    if not self:is_ready() then
        return 0
    end

    return self:get_node_number(4, 3)
end

function WKSHud:has_mission()
    self:open_mission_menu()
    Ferret:wait_until(function()
        return Addons.WKSMission:is_visible() or Addons.WKSMissionInfomation:is_visible()
    end)

    return Addons.WKSMissionInfomation:is_visible()
end


return WKSHud()
