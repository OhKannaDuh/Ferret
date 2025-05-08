--------------------------------------------------------------------------------
--   DESCRIPTION: Red Alert mission farming
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

require('Ferret/FerretCore')
require('Ferret/CosmicExploration/Library')

---@class RedAlert : FerretCore, Translation
RedAlert = FerretCore:extend()
RedAlert:implement(Translation)

function RedAlert:new()
    self.translation_path = 'templates.red_alert'

    RedAlert.super.new(self, self:translate('name'))
    self.template_version = Version(0, 2, 0)

    self.mission = nil
    self.turn_in = Targetable('Collection Point')
end

function RedAlert:setup()
    Logger:info(self.name .. ': ' .. self.template_version:to_string())

    if self.mission == nil then
        Logger:warn('No mission configured')
        return false
    end

    Jobs.change_to(self.mission.job)

    PauseYesAlready()

    return true
end

function RedAlert:loop()
    CosmicExploration:open_mission_menu()
    Addons.WKSMission:open_provisional_missions()

    if not self.mission:start() then
        Logger:warn('Failed to start mission')
        return
    end

    self.mission:handle(MissionResult.Gold)

    CosmicExploration:open_mission_infomation()
    RequestManager:request(Requests.STOP_CRAFT)

    self.turn_in:interact()
    Addons.WKSMissionInfomation:wait_until_not_ready()
end

---@return boolean
---@diagnostic disable-next-line: duplicate-set-field
function Mission:is_complete(goal) -- Certified jank + cringe = win
    return GetItemCount(48233) <= 12
end

local stellar_missions = RedAlert()
Ferret = stellar_missions

return stellar_missions
