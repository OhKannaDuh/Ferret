--------------------------------------------------------------------------------
--   DESCRIPTION: CosmicExploration Mission
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Mission : Object, Translation
---@field id integer
---@field name Translatable
---@field job integer
---@field class string
---@field time_limit number
---@field silver_threshold number
---@field gold_threshold number
---@field has_secondary_job boolean
---@field secondary_job integer|nil
---@field cosmocredit number
---@field lunarcredit number
---@field exp_reward table
---@field has_multiple_recipes boolean
---@field multi_craft_config table
Mission = Object:extend()
Mission:implement(Translation)

Mission.wait_timers = {
    pre_synthesize = 0,
    post_synthesize = 0,
}

Mission.last_crafting_action_threshold = 15

---@param id integer
---@param name Translatable
---@param job Job
---@param class string
function Mission:new(id, name, job, class)
    self.id = id
    self.name = name
    self.job = job
    self.class = class

    self.time_limit = 0
    self.silver_threshold = 0
    self.gold_threshold = 0
    self.has_secondary_job = false
    self.secondary_job = nil
    self.cosmocredit = 0
    self.lunarcredit = 0
    self.exp_reward = {}
    self.has_multiple_recipes = false
    self.multi_craft_config = {}

    self.translation_path = 'modules.cosmic_exploration.mission'
end

---@param name string
---@return Mission
function Mission:with_de_name(name)
    self.name = self.name:with_de(name)
    return self
end

---@param name string
---@return Mission
function Mission:with_fr_name(name)
    self.name = self.name:with_fr(name)
    return self
end

---@param name string
---@return Mission
function Mission:with_jp_name(name)
    self.name = self.name:with_jp(name)
    return self
end

---@param time_limit integer
---@return Mission
function Mission:with_time_limit(time_limit)
    self.time_limit = time_limit
    return self
end

---@param silver_threshold integer
---@return Mission
function Mission:with_silver_threshold(silver_threshold)
    self.silver_threshold = silver_threshold
    return self
end

---@param gold_threshold integer
---@return Mission
function Mission:with_gold_threshold(gold_threshold)
    self.gold_threshold = gold_threshold
    return self
end

---@return Mission
function Mission:with_has_secondary_job()
    self.has_secondary_job = true
    return self
end

---@param job Job
---@return Mission
function Mission:with_secondary_job(job)
    self.secondary_job = job
    return self:with_has_secondary_job()
end

---@param cosmocredit integer
---@return Mission
function Mission:with_cosmocredit(cosmocredit)
    self.cosmocredit = cosmocredit
    return self
end

---@param lunarcredit integer
---@return Mission
function Mission:with_lunarcredit(lunarcredit)
    self.lunarcredit = lunarcredit
    return self
end

---@param reward table
---@return Mission
function Mission:with_exp_reward(reward)
    table.insert(self.exp_reward, reward)
    return self
end

---@return Mission
function Mission:with_multiple_recipes()
    self.has_multiple_recipes = true
    return self
end

---@param config table
---@return Mission
function Mission:with_multi_craft_config(config)
    self.multi_craft_config = config
    return self
end

function Mission:start()
    Addons.WKSMission:wait_until_ready()
    Addons.WKSMission:start_mission(self.id)
end

---@return boolean
function Mission:is_complete()
    return Addons.ToDoList:get_stellar_mission_scores().tier == MissionResult.Gold
        or not self:has_base_crafting_material()
end

---@return MissionScore
function Mission:get_mission_score()
    return Addons.ToDoList:get_stellar_mission_scores()
end

function Mission:wait_for_crafting_ui_or_mission_complete()
    self:log_debug('waiting_for_crafting_ui_or_mission_complete')
    Ferret:wait_until(function()
        return Addons.WKSRecipeNotebook:is_ready() or self:is_complete()
    end)
    Ferret:wait(1)
    self:log_debug('crafting_ui_or_mission_complete')
end

---@return boolean
function Mission:has_base_crafting_material()
    return GetItemCount(48233) > 0
end

---@return boolean, string
function Mission:craft_current()
    local name = Addons.WKSRecipeNotebook:get_current_recipe_name()
    self:log_debug('crafting_current', { name = name })
    local timer = Sandtimer(self.last_crafting_action_threshold)

    Addons.WKSRecipeNotebook:wait_until_ready()

    local craftable = Addons.WKSRecipeNotebook:get_current_craftable_amount()
    if craftable <= 0 then
        return false, self:translate('not_craftable')
    end

    Ferret:wait(Mission.wait_timers.pre_synthesize)
    Addons.WKSRecipeNotebook:synthesize()
    Addons.Synthesis:wait_until_ready()

    timer:flip()
    repeat -- While crafting window is visible
        if Character:has_condition(Conditions.Crafting40) then
            timer:flip()
        end

        if timer:has_run_out() then
            return false, self:translate('timeout')
        end

        Ferret:wait(0.2)
    until not Addons.Synthesis:is_visible()

    return true, self:translate('finished_craft')
end

---@return MissionScore, string
function Mission:single_recipe()
    self:log_debug('recipe_count', { count = 1 })
    local crafted = 0
    repeat
        if not self:has_base_crafting_material() then
            return self:get_mission_score(), self:translate('no_more_to_craft', { crafted = crafted })
        end

        Addons.WKSRecipeNotebook:wait_until_ready()
        local should_continue, reason = self:craft_current()
        if not should_continue then
            return self:get_mission_score(), reason
        end

        crafted = crafted + 1
    until self:is_complete()

    return self:get_mission_score(), self:translate('finished', { crafted = crafted })
end

---@return MissionScore, string
function Mission:multi_recipe()
    self:log_debug('recipe_count', { count = Table:count(self.multi_craft_config) })
    local crafted = 0

    repeat
        if not self:has_base_crafting_material() then
            return self:get_mission_score(), self:translate('no_more_to_craft', { crafted = crafted })
        end

        for index, count in pairs(self.multi_craft_config) do
            Addons.WKSRecipeNotebook:wait_until_ready()
            Addons.WKSRecipeNotebook:set_index(index)
            Addons.WKSRecipeNotebook:set_hq()
            for i = 1, count do
                Addons.WKSRecipeNotebook:wait_until_ready()
                self:craft_current()

                crafted = crafted + 1
            end
        end
    until self:is_complete()

    return self:get_mission_score(), self:translate('finished', { crafted = crafted })
end

---@return MissionScore, string
function Mission:handle()
    self:log_debug('starting_mission', { mission = self.name:get() })

    if not self.has_multiple_recipes then
        return self:single_recipe()
    else
        return self:multi_recipe()
    end
end

function Mission:report()
    Addons.WKSHud:open_mission_menu()
    Addons.WKSMissionInfomation:report()
end

function Mission:abandon()
    Addons.WKSHud:open_mission_menu()
    Addons.WKSMissionInfomation:abandon()
end

---@return string
function Mission:to_string()
    return string.format(
        '[\n    ID: %s,\n    Name: %s,\n    Job: %s,\n    Class: %s\n]',
        self.id,
        self.name:get(),
        self.job,
        self.class
    )
end
