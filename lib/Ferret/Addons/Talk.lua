--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for the Talking NPC popup
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Talk : Addon
local Talk = Addon:extend()
function Talk:new()
    Talk.super.new(self, 'Talk')
end

function Talk:progress_until_done()
    Ferret:repeat_until(function()
        yield('/click Talk Click')
    end, function()
        return not self:is_visible()
    end)
end

return Talk()
