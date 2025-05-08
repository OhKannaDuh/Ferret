--------------------------------------------------------------------------------
--   DESCRIPTION: Stellar Crafting Mission automator
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

Template = require('Ferret/Templates/Template')
require('Ferret/CosmicExploration/Library')

---@class GatheringSpam : Template
GatheringSpam = Template:extend()

function GatheringSpam:new()
    GatheringSpam.super.new(self, 'gathering', Version(2, 9, 0))

    self.mission = nil

    self.stop_on_failure = false
end

function GatheringSpam:init()
    Template.init(self)

    CosmicExploration:init()

    return self
end

function GatheringSpam:setup()
    if not self.mission then
        Logger:warn('Set up a mission bozo')
        return false
    end

    PauseYesAlready()

    return true
end

function GatheringSpam:loop()
    if not CosmicExploration:open_mission_menu() then
        Logger:warn('Sad times are upon us')
        self:stop()
        return
    end

    local available_missions = Addons.WKSMission:get_available_missions()
    if not available_missions:has_id(self.mission.id) then
        local class = self.mission.class
        local classMission = available_missions:filter_by_class(class):random()

        classMission:start()
        Addons.WKSMissionInfomation:graceful_open()
        Addons.WKSMissionInfomation:wait_until_ready()
        classMission:abandon()

        return
    end

    GatheringMissionHandler:handle(self.mission, MissionResult.Gold)
end

return GatheringSpam():init()
