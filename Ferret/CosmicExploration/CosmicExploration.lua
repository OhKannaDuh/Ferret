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
end

---@param job Job
function CosmicExploration:set_job(job)
    self.job = job

    self:log_debug('messages.job_list', { job = Jobs.to_string(job) })

    self.mission_list = MasterMissionList:filter_by_job(job)
end

function CosmicExploration:init()
    self:set_job(GetClassJobId())

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

        Character:wait_until_available()

        Addons.WKSMission:graceful_open()
        if Addons.WKSMission:is_ready() then
            -- We're not in a mission, so we can't open the recipe WKSRecipeNotebook
            -- We can just return here
            return
        end

        Addons.WKSRecipeNotebook:graceful_open()
    end)
end

function CosmicExploration:create_job_list(callback)
    return self.mission_list:filter(callback)
end

function CosmicExploration:create_job_list_by_names(names)
    return self.mission_list:filter_by_names(names)
end

function CosmicExploration:create_job_list_by_ids(ids)
    return self.mission_list:filter_by_ids(ids)
end

---@return boolean
function CosmicExploration:open_mission_menu()
    Addons.WKSMission:graceful_open()
    if not Addons.WKSMission:is_ready() then
        Addons.WKSMissionInfomation:abandon()
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
