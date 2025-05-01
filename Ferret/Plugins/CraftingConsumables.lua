--------------------------------------------------------------------------------
--   DESCRIPTION: Plugin that consumes food and medicine before crafting
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class CraftingConsumables : Plugin
---@field food string
---@field food_threshold integer
---@field medicine string
---@field medicine_threshold integer
---@field wait_time integer The time to wait before drinking medicine after eating food
CraftingConsumables = Plugin:extend()
function CraftingConsumables:new()
    CraftingConsumables.super.new(self, 'Crafting Consumables', 'crafting_consumables')
    self.food = ''
    self.food_threshold = 5
    self.medicine = ''
    self.medicine_threshold = 5

    self.wait_time = 5

    self.should_eat = function(context)
        return true
    end

    self.should_drink = function(context)
        return true
    end
end

function CraftingConsumables:init()
    Ferret:subscribe(Hooks.PRE_CRAFT, function(context)
        Logger:debug_t('plugins.crafting_consumables.pre_craft_start')
        -- Food
        if self:should_eat(context) and (self.food ~= nil and self.food ~= '') then
            local remaining = self:get_remaining_food_time()
            if remaining <= self.food_threshold then
                Logger:debug_t('plugins.crafting_consumables.eating_food', { food = self.food })
                yield('/item ' .. self.food)
                Ferret:wait_until(function()
                    return self:get_remaining_food_time() > remaining
                end)

                if self:should_drink(context) and (self.medicine ~= nil and self.medicine ~= '') then
                    Ferret:wait(self.wait_time)
                end
            else
                Logger:debug_t('plugins.crafting_consumables.food_above_time', { time = self.food_threshold })
            end
        end

        if self:should_drink(context) and (self.medicine ~= nil and self.medicine ~= '') then
            local remaining = self:get_remaining_medicine_time()
            if remaining <= self.medicine_threshold then
                Logger:debug_t('plugins.crafting_consumables.drinking_medicine', { medicine = self.medicine })
                yield('/item ' .. self.medicine)
                Ferret:wait_until(function()
                    return self:get_remaining_medicine_time() > remaining
                end)
            else
                Logger:debug_t('plugins.crafting_consumables.medicine_above_time', { time = self.medicine_threshold })
            end
        end
    end)
end

---@return integer
function CraftingConsumables:get_remaining_food_time()
    return math.floor(GetStatusTimeRemaining(Status.WellFed) / 60)
end

---@return integer
function CraftingConsumables:get_remaining_medicine_time()
    return math.floor(GetStatusTimeRemaining(Status.Medicated) / 60)
end

Ferret:add_plugin(CraftingConsumables())
