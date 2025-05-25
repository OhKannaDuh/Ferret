--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for Quest list (Not Journal)
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Synthesis : Addon
local Synthesis = Addon:extend()
Synthesis:implement(AddonMixins.GracefulClose)

function Synthesis:new()
    Synthesis.super.new(self, 'Synthesis')
end

return Synthesis()
