--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for ShopExchangeCurrency (Shop screen)
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class ShopExchangeCurrency : Addon
local ShopExchangeCurrency = Addon:extend()
ShopExchangeCurrency:implement(AddonMixins.GracefulClose, AddonMixins.GracefulOpen)

function ShopExchangeCurrency:new()
    ShopExchangeCurrency.super.new(self, 'ShopExchangeCurrency')
end

function ShopExchangeCurrency:switch_tab(index)
    self:callback(true, 4, -1, 1, index)
end

function ShopExchangeCurrency:buy(index, amount)
    self:callback(true, 0, index, amount)
end

return ShopExchangeCurrency()
