--------------------------------------------------------------------------------
--   DESCRIPTION: Cosmic Exploration module
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class CosmicExploration : Object
---@field job Job
---@field mission_list MissionList
CosmicExploration = Object:extend()
function CosmicExploration:new()
    self.job = GetClassJobId()
    self.mission_list = MasterMissionList:filter_by_job(self.job)

    EventManager:subscribe(Events.STOP_CRAFT, function(context)
        Logger:debug('Event STOP_CRAFT called from Cosmic Exploration')

        if Addons.Synthesis:graceful_close() then
            Addons.WKSRecipeNotebook:wait_until_ready()
        end

        Addons.WKSRecipeNotebook:graceful_close()

        Character:wait_until_available()
    end)

    EventManager:subscribe(Events.PREPARE_TO_CRAFT, function(context)
        Logger:debug('Event PREPARE_TO_CRAFT called from Cosmic Exploration')

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

---@param job Job
function CosmicExploration:set_job(job)
    self.job = job
    self.mission_list = MasterMissionList:filter_by_job(job)
end
