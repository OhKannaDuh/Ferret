--------------------------------------------------------------------------------
--   DESCRIPTION: Stellar Crafting Mission automator
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

Base = require('Ferret/FerretCore')
require('Ferret/CosmicExploration/Library')

MissionOrder = {
    TopPriority = 1, -- Execute missions in the order they are listed
    Random = 2, -- Execute missions in random order
}

StellarMissions = Base:extend()
function StellarMissions:new()
    StellarMissions.super.new(self, i18n('templates.stellar_missions.name'))
    self.template_version = Version(2, 8, 2)

    self.mission_list = MissionList()
    self.mission_order = MissionOrder.TopPriority

    self.minimum_acceptable_result = MissionResult.Gold
    self.per_mission_acceptable_result = {}

    self.minimum_target_result = MissionResult.Gold
    self.per_mission_target_result = {}

    self.stop_on_failure = false
end

function StellarMissions:init()
    Base.init(self)

    Logger:info(self.name .. ': ' .. self.template_version:to_string())
    CosmicExploration:init()

    return self
end

function StellarMissions:get_acceptable_result(mission)
    if self.per_mission_target_result[mission.id] then
        return self.per_mission_target_result[mission.id]
    end

    if self.per_mission_acceptable_result[mission.id] then
        return self.per_mission_acceptable_result[mission.id]
    end

    if self.minimum_target_result < self.minimum_acceptable_result then
        return self.minimum_target_result
    end

    return self.minimum_acceptable_result
end

function StellarMissions:get_target_result(mission)
    if self.per_mission_target_result[mission.id] then
        return self.per_mission_target_result[mission.id]
    end

    return self.minimum_target_result
end

function StellarMissions:setup()
    if self.mission_list:is_empty() then
        Logger:warn('No missions taken from configured mission list')
        return false
    end

    PauseYesAlready()

    return true
end

function StellarMissions:loop()
    RequestManager:request(Requests.STOP_CRAFT)
    if not CosmicExploration:open_mission_menu() then
        Logger:warn('Sad times are upon us')
        self:stop()
        return
    end

    local timer = Timer()
    timer:start()
    local available_missions = Addons.WKSMission:get_available_missions()
    Logger:list('Available Missions', available_missions.missions)
    Logger:debug('Took: ' .. timer:seconds())

    local overlap = self.mission_list:get_overlap(available_missions)

    if overlap:is_empty() then
        Logger:debug('Selecting mission to abandon')
        local class = Table:random(self.mission_list:get_classes())
        Logger:debug('Abandoning mission of class: ' .. class)

        local mission = available_missions:filter_by_class(class):random()
        if mission == nil then
            Logger:debug('No mission found with class: ' .. class)
            mission = available_missions:random()
        end

        if mission == nil then
            Logger:warn('Could not determine a mission to abandon.')
            Logger:info('Configured missions: ' .. self.mission_list:count())
            Logger:info('Available missions: ' .. available_missions:count())
            self:stop()
            return
        end

        mission:start()
        Addons.WKSRecipeNotebook:wait_until_ready()
        mission:abandon()
        return
    else
        Logger:debug('Selecting mission to run')
        local mission = nil
        if self.mission_order == MissionOrder.TopPriority then
            mission = overlap:first()
        elseif self.mission_order == MissionOrder.Random then
            mission = overlap:random()
        end

        if mission == nil then
            Logger:error('Error getting a mission.')
            self:stop()
            return
        end

        Logger:debug('mission: ' .. mission:to_string())

        mission:start()

        Addons.WKSRecipeNotebook:wait_until_ready()
        Addons.WKSHud:open_mission_menu()

        local goal = self:get_target_result(mission)
        Logger:info('Mission target: ' .. MissionResult.to_string(goal))

        local result, reason = mission:handle(goal)
        Logger:debug('Result: ' .. MissionResult.to_string(result.tier))
        Logger:debug('Acceptable: ' .. MissionResult.to_string(self:get_acceptable_result(mission)))

        RequestManager:request(Requests.STOP_CRAFT)

        if result.tier < self:get_acceptable_result(mission) then
            Logger:warn('Mission failed: ' .. mission:to_string())
            Logger:warn('Reason: ' .. reason)

            if self.stop_on_failure then
                Logger:info('Quiting Ferret ' .. self.version:to_string())
                self:stop()
            end
        end

        mission:finish(result.tier)
    end
end

return StellarMissions():init()
