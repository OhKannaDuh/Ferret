--------------------------------------------------------------------------------
--   DESCRIPTION: Cosmic Exploration module
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class CosmicExploration : Object, Translation
---@field job Job
---@field mission_list MissionList
local CosmicExploration = Object:extend()
CosmicExploration:implement(Translation)

function CosmicExploration:new()
    self.translation_path = 'modules.cosmic_exploration'

    self.version = Version(0, 1, 1)

    self.mission_list = MissionList()

    self.minimum_acceptable_result = MissionResult.Gold
    self.per_mission_acceptable_result = {}

    self.minimum_target_result = MissionResult.Gold
    self.per_mission_target_result = {}
end

---@param job Job
function CosmicExploration:set_job(job)
    self.job = job

    self:log_debug('messages.job_list', { job = Jobs.to_string(job) })

    self.mission_list = MasterMissionList:filter_by_job(job)
end

function CosmicExploration:init()
    self:set_job(GetClassJobId())

    self:log_info("Initialising Cosmic Exploration module " .. self.version:to_string())

    self:log_debug('messages.registering_callbacks')
    RequestManager:subscribe(Requests.STOP_CRAFT, function(context)
        Logger:debug('Request STOP_CRAFT called from Cosmic Exploration')

        if Addons.Synthesis:graceful_close() then
            Addons.WKSRecipeNotebook:wait_until_ready()
        end

        Addons.WKSRecipeNotebook:graceful_close()

        Character:wait_until_available()
    end)

    RequestManager:subscribe(Requests.PREPARE_TO_CRAFT, function(context)
        Logger:debug('Request PREPARE_TO_CRAFT called from Cosmic Exploration')

        if Addons.WKSRecipeNotebook:is_ready() then
            return
        end

        Addons.WKSMission:graceful_open()
        if Addons.WKSMission:is_ready() then
            -- We're not in a mission, so we can't open the recipe WKSRecipeNotebook
            -- We can just return here
            return
        end

        Addons.WKSRecipeNotebook:graceful_open()
    end)
end

---@return MissionList
function CosmicExploration:create_mision_list(callback)
    return self.mission_list:filter(callback)
end

---@return MissionList
function CosmicExploration:create_mission_list_from_names(names)
    return self.mission_list:filter_by_names(names)
end

---@return MissionList
function CosmicExploration:create_mission_list_from_ids(ids)
    return self.mission_list:filter_by_ids(ids)
end

---@return MissionResult
function CosmicExploration:get_acceptable_result(mission)
    if self.per_mission_target_result[mission.id] then
        return self.per_mission_target_result[mission.id]
    end

    if self.per_mission_acceptable_result[mission.id] then
        return self.per_mission_acceptable_result[mission.id]
    end

    return math.min(self.minimum_target_result, self.minimum_acceptable_result)
end

---@return MissionResult
function CosmicExploration:get_target_result(mission)
    if self.per_mission_target_result[mission.id] then
        return self.per_mission_target_result[mission.id]
    end

    return self.minimum_target_result
end

---@return boolean
function CosmicExploration:open_mission_menu()
    Addons.WKSMission:graceful_open()
    if not Addons.WKSMission:is_ready() then
        Addons.WKSMissionInfomation:abandon()
        Addons.WKSMissionInfomation:wait_until_not_ready()
        Addons.WKSMission:graceful_open()
    end

    return Addons.WKSMission:is_ready()
end

---@return boolean
function CosmicExploration:open_mission_infomation()
    Addons.WKSMissionInfomation:graceful_open()
    return not Addons.WKSMissionInfomation:is_ready()
end

return CosmicExploration()
