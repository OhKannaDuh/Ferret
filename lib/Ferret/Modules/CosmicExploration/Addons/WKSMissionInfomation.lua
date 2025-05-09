--------------------------------------------------------------------------------
--   DESCRIPTION: Cosmic exploration mission report window
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class WKSMissionInfomation : Addon, Translation
local WKSMissionInfomation = Addon:extend()
WKSMissionInfomation:implement(Translation)

function WKSMissionInfomation:new()
    WKSMissionInfomation.super.new(self, 'WKSMissionInfomation')
    self.ready_max = 5
    self.visible_max = 5

    self.translation_path = 'modules.cosmic_exploration.wks_mission_information'
end
function WKSMissionInfomation:open()
    Addons.WKSHud:open_mission_menu()
end

-- Requires it's own implementation because it shares an opening method with WKSMission
function WKSMissionInfomation:graceful_open()
    if self:is_ready() or Addons.WKSMission:is_ready() then
        return false
    end

    repeat
        self:open()
        Wait:fps(5)
    until self:is_ready() or Addons.WKSMission:is_ready()

    return self:is_ready()
end

function WKSMissionInfomation:report()
    self:log_debug('report')
    Debug:log_previous_call()

    self:callback(true, 11)
end

function WKSMissionInfomation:abandon()
    repeat
        if self:is_ready() then
            self:callback(true, 12)
        end
        Ferret:wait(0.1)
    until Addons.SelectYesno:is_visible()
    repeat
        if Addons.SelectYesno:is_ready() then
            Addons.SelectYesno:yes()
        end
        Ferret:wait(0.1)
    until not WKSMissionInfomation:is_visible()
end

function WKSMissionInfomation:open_cosmopouch()
    self:callback(true, 13)
end

function WKSMissionInfomation:graceful_open_cosmopouch()
    -- if Addons.
    return false
end

function WKSMissionInfomation:open_craftinglog()
    self:callback(true, 14)
end

function WKSMissionInfomation:graceful_open_craftinglog()
    if Addons.WKSRecipeNotebook:is_ready() then
        return false
    end

    repeat
        self:open_craftinglog()
        Wait:fps(5)
    until Addons.WKSRecipeNotebook:is_ready()
end

function WKSMissionInfomation:get_silver_requirement()
    return self:get_node_number(11)
end

function WKSMissionInfomation:get_gold_requirement()
    return self:get_node_number(15)
end

function WKSMissionInfomation:get_time_limit()
    return self:get_node_text(24)
end

function WKSMissionInfomation:get_current_score()
    return self:get_node_number(24)
end

function WKSMissionInfomation:get_time_limit_label()
    return self:get_node_text(25)
end

function WKSMissionInfomation:get_mission_name()
    return self:get_node_text(29)
end

return WKSMissionInfomation()
