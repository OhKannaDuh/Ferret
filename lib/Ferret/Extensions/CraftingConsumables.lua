--------------------------------------------------------------------------------
--   DESCRIPTION: Extension that consumes food and medicine before crafting
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class CraftingConsumables : Extension
---@field food string
---@field food_threshold integer
---@field medicine string
---@field medicine_threshold integer
---@field wait_time integer The time to wait before drinking medicine after eating food
local CraftingConsumables = Extension:extend()
function CraftingConsumables:new()
    CraftingConsumables.super.new(self, 'Crafting Consumables', 'crafting_consumables')

    self.food = ''
    self.food_threshold = 5
    self.medicine = ''
    self.medicine_threshold = 5

    self.wait_time = 5
    self.max_attempts = 3

    self.should_eat = function(plugin, context)
        return true
    end

    self.should_drink = function(plugin, context)
        return true
    end
end

function CraftingConsumables:init()
    EventManager:subscribe(Events.PRE_CRAFT, function(context)
        self:log_debug('pre_craft_start')

        local food_remaining = self:get_remaining_food_time()
        local should_eat = self:should_eat(context) and self.food ~= '' and food_remaining <= self.food_threshold

        local medicine_remaining = self:get_remaining_medicine_time()
        local should_drink = self:should_drink(context)
            and self.medicine ~= ''
            and medicine_remaining <= self.medicine_threshold

        if not should_eat and not should_drink then
            return
        end

        RequestManager:request(Requests.STOP_CRAFT)

        if should_eat then
            self:log_debug('eating_food', { food = self.food })
            local attempt = 0

            repeat
                yield('/item ' .. self.food)
                attempt = attempt + 1

                Ferret:wait_until(function()
                    return self:get_remaining_food_time() > food_remaining
                end, 0.5, self.wait_time * 2)
            until self:get_remaining_food_time() > food_remaining or attempt >= self.max_attempts

            if should_drink then
                Ferret:wait(self.wait_time)
            end
        end

        -- Medicine
        if should_drink then
            self:log_debug('drinking_medicine', { medicine = self.medicine })
            local attempt = 0

            repeat
                yield('/item ' .. self.medicine)
                attempt = attempt + 1

                Ferret:wait_until(function()
                    return self:get_remaining_medicine_time() > medicine_remaining
                end, 0.5, self.wait_time * 2)
            until self:get_remaining_medicine_time() > medicine_remaining or attempt >= self.max_attempts
        end

        RequestManager:request(Requests.PREPARE_TO_CRAFT)
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

return CraftingConsumables()
