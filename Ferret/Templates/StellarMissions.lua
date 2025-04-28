--------------------------------------------------------------------------------
--   DESCRIPTION: Stellar Crafting Mission automator
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

require('Ferret/Ferret')
require('Ferret/CosmicExploration/CosmicExploration')

MissionOrder = {
    TopPriority = 1, -- Execute missions in the order they are listed
    Random = 2, -- Execute missions in random order
}

StellarMissions = Ferret:extend()
function StellarMissions:new()
    StellarMissions.super.new(self, 'Stellar Missions')

    self.mission_list = MissionList()
    self.mission_order = MissionOrder.TopPriority
    self.missions_to_medicate_on = {}
    self.medicine_to_drink = nil
    self.food_to_eat = nil
    self.job = nil
    self.template_version = Version(2, 2, 1)

    self.cosmic_exploration = CosmicExploration()

    self.wait_timers = {
        pre_open_mission_list = 0,
        post_open_mission_list = 0,
        post_mission_start = 0,
        post_mission_abandon = 0,
    }

    self:init()
end

function StellarMissions:slow_mode()
    self.wait_timers = {
        pre_open_mission_list = 1,
        post_open_mission_list = 1,
        post_mission_start = 1,
        post_mission_abandon = 1,
    }

    Mission.wait_timers.pre_synthesize = 1
    Mission.wait_timers.post_synthesize = 1
end

function StellarMissions:create_job_list(callback)
    return MasterMissionList:filter_by_job(self.job):filter(callback)
end

function StellarMissions:create_job_list_by_names(names)
    return MasterMissionList:filter_by_job(self.job):filter_by_names(names)
end

function StellarMissions:create_job_list_by_ids(ids)
    return MasterMissionList:filter_by_job(self.job):filter_by_names(ids)
end

function StellarMissions:setup()
    Logger:info('Stellar missions ' .. self.template_version:to_string())

    if self.job == nil then
        Logger:error('Job not set')
        Logger:info('Please set `stellar_missions.job = Jobs.Carpenter` etc.')
        return false
    end

    self.cosmic_exploration:set_job(self.job)

    local error = false
    if self.mission_list.missions == nil then
        local actual_missions = MissionList()
        for _, mission in pairs(self.mission_list) do
            local found_mission = self.cosmic_exploration.mission_list:find_by_name(mission)

            if found_mission ~= nil then
                Logger:debug(mission .. ': ' .. found_mission:to_string())
                table.insert(actual_missions.missions, found_mission)
            else
                Logger:error(mission .. ': Not found')
                error = true
            end
        end
    end

    if error then
        return false
    end

    PauseYesAlready()

    return true
end

function StellarMissions:loop()
    Logger:debug('Starting loop')

    WKSHud:wait_until_ready()

    Ferret:wait(self.wait_timers.pre_open_mission_list)
    WKSMission:open()
    Ferret:wait(self.wait_timers.post_open_mission_list)

    local available_missions = WKSMission:get_available_missions()
	local mission_list = self.mission_list:get_overlap(available_missions):filter_by_job(self.job)
    local mission_list = self.mission_list:get_overlap(available_missions)

    if self:get_table_length(mission_list.missions) <= 0 then
        local classes = {}
        for _, mission in pairs(self.mission_list.missions) do
            if not self:table_contains(classes, mission.class) then
                table.insert(classes, mission.class)
            end
        end
        Logger:debug('Selecting mission to abandon')
        local class = self:table_random(classes)
        local class_missions = available_missions:filter_by_class(class)
        local mission = class_missions:random()
        if mission == nil then
            mission = available_missions:random()
        end

        Logger:debug('mission: ' .. mission:to_string())

        mission:start()
        Ferret:wait(self.wait_timers.post_mission_start)
        mission:abandon()
        Ferret:wait(self.wait_timers.post_mission_abandon)
        return
    else
        Logger:debug('Selecting mission to run')
        local mission = nil
        if self.mission_order == MissionOrder.TopPriority then
            mission = mission_list:first()
        elseif self.mission_order == MissionOrder.Random then
            mission = mission_list:random()
        end

        if mission == nil then
            Logger:error('Error getting a mission.')
            self:stop()
            return
        end

        Logger:debug('mission: ' .. mission:to_string())
        mission:start()
        Ferret:wait(self.wait_timers.post_mission_start)
        WKSRecipeNotebook:wait_until_ready()
        self:emit(Hooks.PRE_CRAFT)

        WKSHud:open_mission_menu()

        if not mission:handle() then
            Logger:error('Mission failed: ' .. mission:to_string())
            self:stop()
            return
        end

        self:repeat_until(function()
            mission:report()
        end, function()
            return not mission:is_complete()
        end)
    end
end

local stellar_missions = StellarMissions()
Ferret = stellar_missions

return stellar_missions
