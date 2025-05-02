--------------------------------------------------------------------------------
--   DESCRIPTION: Red Alert mission farming
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

require('Ferret/Ferret')
require('Ferret/CosmicExploration/CosmicExploration')

---@class RedAlert : Ferret, Translation
RedAlert = Ferret:extend()
RedAlert:implement(Translation)

function RedAlert:new()
    self.translation_path = 'templates.red_alert'

    RedAlert.super.new(self, self:translate('name'))
    self.template_version = Version(0, 1, 0)

    self.mission = nil
    self.turn_in = Targetable('Collection Point')

    self.cosmic_exploration = CosmicExploration()
end

function RedAlert:setup()
    Logger:info(self.name .. ': ' .. self.template_version:to_string())

    if self.mission == nil then
        Logger:warn('No mission configured')
        return false
    end

    PauseYesAlready()

    return true
end

function RedAlert:loop()
    Addons.WKSHud:wait_until_ready()

    repeat
        Addons.WKSMission:open()
        Ferret:wait(0.2)
    until Addons.WKSMission:is_ready()

    Addons.WKSMission:open_critical_missions()
    self.mission:start()
    Addons.WKSRecipeNotebook:wait_until_ready()
    HookManager:emit(Hooks.PRE_CRAFT, {
        mission = self.mission,
    })

    Addons.WKSHud:open_mission_menu()

    self.mission:handle(MissionResult.Gold)

    Addons.WKSHud:open_mission_menu()
    Addons.WKSMissionInfomation:wait_until_ready()

    self.turn_in:interact()
    Ferret:wait(3) -- Adjust this wait time
end

---@return boolean
---@diagnostic disable-next-line: duplicate-set-field
function Mission:is_complete(goal) -- Certified jank + cringe = win
    return GetItemCount(48233) <= 12
end

local stellar_missions = RedAlert()
Ferret = stellar_missions

return stellar_missions
