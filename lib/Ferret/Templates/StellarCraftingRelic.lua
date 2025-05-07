--------------------------------------------------------------------------------
--   DESCRIPTION: Stellar Crafting Relic automator
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

Template = require('Ferret/Templates/Template')
require('Ferret/CosmicExploration/Library')

---@class StellarCraftingRelic : Template
StellarCraftingRelic = Template:extend()

function StellarCraftingRelic:new()
    StellarCraftingRelic.super.new(self, 'stellar_crafting_relic', Version(0, 10, 3))

    self.job_order = {
        Jobs.Carpenter,
        Jobs.Blacksmith,
        Jobs.Armorer,
        Jobs.Goldsmith,
        Jobs.Leatherworker,
        Jobs.Weaver,
        Jobs.Alchemist,
        Jobs.Culinarian,
    }

    self.relic_ranks = {}
    self.progress = {}

    self.wait_timers = {
        pre_open_mission_list = 0,
        post_open_mission_list = 0,
        post_mission_start = 0,
        post_mission_abandon = 0,
    }

    self.blacklist = MissionList()
    self.actual_blacklist = MissionList()
    self.auto_blacklist = true

    self.researchingway = Targetable(i18n('npcs.researchingway'))
end

function StellarCraftingRelic:init()
    Template.init(self)

    CosmicExploration:init()

    return self
end

function StellarCraftingRelic:setup()
    self:setup_blacklist()

    PauseYesAlready()

    return true
end

function StellarCraftingRelic:loop()
    RequestManager:request(Requests.STOP_CRAFT)
    if not CosmicExploration:open_mission_menu() then
        Logger:warn('Sad times are upon us')
        self:stop()
        return
    end

    Addons.WKSToolCustomize:graceful_open()
    Logger:info_t('templates.stellar_crafting_relic.checking_relic_ranks')
    self.relic_ranks = Addons.WKSToolCustomize:get_relic_ranks()
    self.progress = Addons.WKSToolCustomize:get_progress()
    Addons.WKSToolCustomize:graceful_close()

    local job = self:get_first_unmaxed_job()
    if job == Jobs.Unknown then
        Logger:info_t('templates.stellar_crafting_relic.maxed')
        self:stop()
        return
    end

    if job ~= GetClassJobId() then
        Jobs.change_to(job)
        CosmicExploration:set_job(job)
        self:setup_blacklist()
        Character:wait_until_available()
        Wait:seconds(2)
        return
    end

    if self:is_ready_to_upgrade() then
        self:upgrade()
        return
    end

    local mission = Addons.WKSMission:get_best_available_mission(self.actual_blacklist, self.progress)
    if mission == nil then
        Logger:warn_t('templates.stellar_crafting_relic.failed_to_get_mission')
        Logger:info('Quiting Ferret ' .. self.version:to_string())
        self:stop()
        return
    end

    Logger:info_t('templates.stellar_crafting_relic.mission', { mission = mission:to_string() })

    if not mission:start() then
        Logger:warn('Failed to start mission')
        return
    end

    local goal = CosmicExploration:get_target_result(mission)
    Logger:info('Mission target: ' .. MissionResult.to_string(goal))

    local result, reason = mission:handle(goal)
    local acceptable = CosmicExploration:get_acceptable_result(mission)

    Logger:debug('Result: ' .. tostring(result))
    Logger:debug('Acceptable: ' .. MissionResult.to_string(acceptable))

    RequestManager:request(Requests.STOP_CRAFT)

    if result.tier < acceptable then
        Logger:warn_t('templates.stellar_crafting_relic.mission_failed', { mission = mission:to_string() })
        Logger:warn('Reason: ' .. reason)

        if self.auto_blacklist then
            Logger:warn_t('templates.stellar_crafting_relic.mission_blacklisting', { mission = mission.name:get() })
            self.actual_blacklist:add(mission)
        end
    end

    Logger:debug_t('templates.stellar_crafting_relic.mission_complete')

    mission:finish(result.tier)
end

function StellarCraftingRelic:setup_blacklist()
    self.actual_blacklist = MissionList()
    for _, mission in ipairs(self.blacklist.missions) do
        self.actual_blacklist:add(mission)
    end
end

function StellarCraftingRelic:get_first_unmaxed_job()
    for _, job in ipairs(self.job_order) do
        if self.relic_ranks[job] < 9 then
            return job
        end
    end

    return Jobs.Unknown
end

function StellarCraftingRelic:is_ready_to_upgrade()
    for i, exp in ipairs(self.progress) do
        if Table:count(exp) > 0 then
            if exp.current < exp.required then
                return false
            end
        end
    end

    return true
end

function StellarCraftingRelic:upgrade()
    local text_advance = HasPlugin('TextAdvance')
    if text_advance then
        yield('/at disable')
    end

    self.researchingway:interact()
    Addons.Talk:wait_until_ready()
    Addons.Talk:progress_until_done()

    Addons.SelectString:wait_until_ready()
    Addons.SelectString:select_index(0)

    Addons.SelectIconString:wait_until_ready()
    Addons.SelectIconString:select_index(CosmicExploration.job - 8)

    Addons.SelectYesno:wait_until_ready()
    Addons.SelectYesno:yes()

    Addons.Talk:wait_until_ready()
    Addons.Talk:progress_until_done()

    Wait:seconds(2)

    if text_advance then
        yield('/at enable')
    end
end

return StellarCraftingRelic():init()
