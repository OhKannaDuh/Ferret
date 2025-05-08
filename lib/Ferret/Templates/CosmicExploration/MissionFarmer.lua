--------------------------------------------------------------------------------
--   DESCRIPTION: Stellar Crafting Mission automator
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

Template = require('Ferret/Templates/Template')
require('Ferret/CosmicExploration/Library')

MissionOrder = {
    TopPriority = 1, -- Execute missions in the order they are listed
    Random = 2, -- Execute missions in random order
}

---@class MissionFarmer : Template
MissionFarmer = Template:extend()

function MissionFarmer:new()
    MissionFarmer.super.new(self, 'stellar_missions', Version(2, 9, 0))

    self.mission_list = MissionList()
    self.mission_order = MissionOrder.TopPriority

    self.stop_on_failure = false
end

function MissionFarmer:init()
    Template.init(self)

    CosmicExploration:init()

    return self
end

function MissionFarmer:setup()
    if self.mission_list:is_empty() then
        Logger:warn('No missions taken from configured mission list')
        return false
    end

    PauseYesAlready()

    return true
end

function MissionFarmer:loop()
    RequestManager:request(Requests.STOP_CRAFT)
    if not CosmicExploration:open_mission_menu() then
        Logger:warn('Sad times are upon us')
        self:stop()
        return
    end

    local mission = self:select_mission()
    if not mission then -- No mission to run, reloop
        return
    end

    Logger:debug('mission: ' .. mission:to_string())

    if not mission:start() then
        Logger:warn('Failed to start mission')
        return
    end

    Addons.WKSMissionInfomation:graceful_open()

    local goal = CosmicExploration:get_target_result(mission)
    Logger:info('Mission target: ' .. MissionResult.to_string(goal))

    local result, reason = CraftingMissionHandler:handle(mission, goal)
    local acceptable = CosmicExploration:get_acceptable_result(mission)

    Logger:debug('Result: ' .. tostring(result))
    Logger:debug('Acceptable: ' .. MissionResult.to_string(acceptable))

    RequestManager:request(Requests.STOP_CRAFT)

    if result.tier < acceptable then
        Logger:warn('Mission failed: ' .. mission:to_string())
        Logger:warn('Reason: ' .. reason)

        if self.stop_on_failure then
            Logger:info('Quiting Ferret ' .. self.version:to_string())
            self:stop()
        end
    end

    mission:finish(result.tier)
end

function MissionFarmer:select_mission()
    local available_missions = Addons.WKSMission:get_available_missions()
    Logger:list('Available', available_missions.missions)

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
    end

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

    return mission
end

return MissionFarmer():init()
