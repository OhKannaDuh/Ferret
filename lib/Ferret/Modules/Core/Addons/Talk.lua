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
    repeat
        yield('/click Talk Click')
        Wait:seconds(0.5)
    until  not self:is_visible()
end

return Talk()
