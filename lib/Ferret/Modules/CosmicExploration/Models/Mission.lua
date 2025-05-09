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

Mission.last_crafting_action_threshold = 5

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

    self.recipe_table_id = 0
    self.recipes = {}

    self.pathfinding = Pathfinding()

    self.is_time_restricted = false
    self.time_restriction = {
        start = 0,
        finish = 0,
    }

    self.weather_restriction = nil

    self.gathering_node_layout = GatheringNodeLayout.Unknown

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

function Mission:with_recipe_table_id(id)
    self.recipe_table_id = id
    return self
end

function Mission:with_recipes(recipes)
    self.recipes = recipes
    return self
end

---@param start integer
---@param finish integer
---@return Mission
function Mission:with_time_restriction(start, finish)
    self.is_time_restricted = true
    self.time_restriction.start = start
    self.time_restriction.finish = finish
    return self
end

---@param weather Weather
---@return Mission
function Mission:with_weather_restriction(weather)
    self.weather_restriction = weather
    return self
end

function Mission:with_gathering_node_layout(layout)
    self.gathering_node_layout = layout
    return self
end

function Mission:with_node(node)
    self.pathfinding:add_node(node)
    return self
end

---@return boolean
function Mission:is_available()
    if self.is_time_restricted then
        return World:is_hour_between(self.time_restriction.start, self.time_restriction.finish)
    end

    if self.weather_restriction then
        return World:is_weather(self.weather_restriction)
    end

    return true
end

function Mission:start()
    Addons.WKSHud:wait_until_ready()
    Addons.WKSMission:graceful_open()
    if not Addons.WKSMission:is_ready() then
        return false
    end

    repeat
        Addons.WKSMission:start_mission(self.id)
        Wait:fps(5)
    until not Addons.WKSMission:is_ready()

    Addons.WKSMissionInfomation:graceful_open()
    return true
end

---@param goal MissionResult
---@return boolean
function Mission:is_complete(goal)
    return Addons.ToDoList:get_stellar_mission_scores().tier >= goal or not self:has_base_crafting_material()
end

---@return MissionScore
function Mission:get_score()
    return Addons.ToDoList:get_stellar_mission_scores()
end

---@param goal MissionResult
function Mission:wait_for_crafting_ui_or_mission_complete(goal)
    self:log_debug('waiting_for_crafting_ui_or_mission_complete')
    Ferret:wait_until(function()
        return Addons.WKSRecipeNotebook:is_ready() or self:is_complete(goal)
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

    local craftable = Addons.WKSRecipeNotebook:get_current_craftable_amount()
    if craftable <= 0 then
        return false, self:translate('not_craftable')
    end

    Addons.WKSRecipeNotebook:graceful_synthesize()
    Addons.Synthesis:wait_until_ready()

    timer:flip()
    repeat -- While crafting window is visible
        if Character:has_condition(Conditions.Crafting40) then
            timer:flip()
        end

        if timer:has_run_out() then
            return false, self:translate('timeout')
        end

        Wait:fps(5)
    until not Addons.Synthesis:is_visible()

    return true, self:translate('finished_craft')
end

function Mission:finish(result)
    if result == MissionResult.Fail and self:has_base_crafting_material() then
        self:abandon()
        return
    end

    self:report()
end

function Mission:report()
    Addons.WKSHud:wait_until_ready()
    Addons.WKSMission:graceful_open()
    if not Addons.WKSMission:is_ready() then
        Addons.WKSMissionInfomation:report()
        Addons.WKSMissionInfomation:wait_until_not_ready()
        return true
    end

    return false
end

function Mission:abandon()
    Addons.WKSHud:wait_until_ready()
    Addons.WKSMission:graceful_open()
    if not Addons.WKSMission:is_ready() then
        Addons.WKSMissionInfomation:abandon()
        Addons.WKSMissionInfomation:wait_until_not_ready()
        return true
    end

    return false
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

function Mission:__tostring()
    return self.name:get()
end
