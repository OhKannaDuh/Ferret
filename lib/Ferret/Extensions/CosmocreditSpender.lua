--------------------------------------------------------------------------------
--   DESCRIPTION: Spend your cosmocredits on things
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class CosmocreditSpender : Extension
---@field threshold integer
---@field item_index integer
local CosmocreditSpender = Extension:extend()
function CosmocreditSpender:new()
    CosmocreditSpender.super.new(self, 'Cosmocredit Spender', 'cosmocredit_spender')

    self.threshold = 20000
    self.item_index = 0
    self.npc = Targetable('Mesouaidonque')
end

function CosmocreditSpender:get_cost()
    if self.item_index < 11 or self.item_index > 38 then
        error('Invalid item index')
    end

    -- 11 = Ruby Red Dye, 23 = Violet Purple Dye
    if self.item_index >= 11 and self.item_index <= 23 then
        return 600
    end

    -- Gunmetal Black Dye, Pearl White Dye & Metallic Brass Dye
    if self.item_index <= 26 then
        return 1500
    end

    -- Materia's 27+ (You can count)
    return 900 - (450 * (self.item_index % 2))
end

function CosmocreditSpender:init()
    EventManager:subscribe(Events.POST_LOOP, function(context)
        Logger:info('Checking Cosmocredits')

        local credits = GetItemCount(45690)
        if GetItemCount(45690) < self.threshold then
            return
        end

        PauseYesAlready()

        RequestManager:request(Requests.STOP_CRAFT)

        self.npc:interact()
        Addons.ShopExchangeCurrency:wait_until_ready()
        Addons.ShopExchangeCurrency:switch_tab(3)

        local amount = math.floor(credits / self:get_cost())
        Addons.ShopExchangeCurrency:buy(self.item_index, amount)
        Addons.SelectYesno:wait_until_ready()
        Addons.SelectYesno:yes()

        RestoreYesAlready()
    end)
end

return CosmocreditSpender()
