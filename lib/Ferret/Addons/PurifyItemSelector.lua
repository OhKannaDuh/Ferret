--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for the Aetherial Reduction screen
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class PurifyItemSelector : Addon
local PurifyItemSelector = Addon:extend()

function PurifyItemSelector:new()
    PurifyItemSelector.super.new(self, 'PurifyItemSelector')
end

function PurifyItemSelector:click_first()
    self:callback(true, 12, 0)
end

function PurifyItemSelector:exit()
    self:callback(true, -1)
end

return PurifyItemSelector()
