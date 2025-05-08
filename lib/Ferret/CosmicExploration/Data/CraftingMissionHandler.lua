--------------------------------------------------------------------------------
--   DESCRIPTION: Handler for doing crafting missions
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class CraftingMissionHandler : Object
local CraftingMissionHandler = Object:extend()

function CraftingMissionHandler:handle(mission, goal)
    -- self:log_debug('starting_mission', { mission = self.name:get() })

    if not mission.has_multiple_recipes then
        return self:single_recipe(mission, goal)
    else
        return self:multi_recipe(mission, goal)
    end
end

---@param mission Mission
---@param goal MissionResult
---@return MissionScore, string
function CraftingMissionHandler:single_recipe(mission, goal)
    -- self:log_debug('recipe_count', { count = 1 })
    local crafted = 0
    repeat
        if not mission:has_base_crafting_material() then
            return mission:get_score(), mission:translate('no_more_to_craft', { crafted = crafted })
        end

        EventManager:emit(Events.PRE_CRAFT, { mission = self })
        RequestManager:request(Requests.PREPARE_TO_CRAFT)

        local should_continue, reason = mission:craft_current()

        -- self:log_debug('reason', { reason = reason })
        if not should_continue then
            return mission:get_score(), reason
        end

        crafted = crafted + 1

        local score = mission:get_score()
        if score.tier >= goal then
            return score, mission:translate('reached_goal', { crafted = crafted })
        end

    until mission:is_complete(goal)

    return mission:get_score(), mission:translate('finished', { crafted = crafted })
end

---@param mission Mission
---@param goal MissionResult
---@return MissionScore, string
function CraftingMissionHandler:multi_recipe(mission, goal)
    -- self:log_debug('recipe_count', { count = Table:count(self.multi_craft_config) })
    local crafted = 0

    repeat
        for index, count in pairs(mission.multi_craft_config) do
            Addons.WKSRecipeNotebook:wait_until_ready(nil, 2)
            if not Addons.WKSRecipeNotebook:is_ready() then
                return mission:get_score(), mission:translate('no_more_to_craft', { crafted = crafted })
            end

            EventManager:emit(Events.PRE_CRAFT, { mission = self })
            RequestManager:request(Requests.PREPARE_TO_CRAFT)

            Addons.WKSRecipeNotebook:set_index(index)
            Addons.WKSRecipeNotebook:set_hq()
            for i = 1, count do
                Addons.WKSRecipeNotebook:wait_until_ready()
                local should_continue, reason = mission:craft_current()
                mission:log_debug('reason', { reason = reason })

                crafted = crafted + 1

                local score = mission:get_score()
                if score.tier >= goal then
                    return score, mission:translate('reached_goal', { crafted = crafted })
                end
            end
        end
    until mission:is_complete(goal)

    return mission:get_score(), mission:translate('finished', { crafted = crafted })
end

return CraftingMissionHandler()
