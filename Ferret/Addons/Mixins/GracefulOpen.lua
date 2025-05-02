--------------------------------------------------------------------------------
--   DESCRIPTION: Gracefully open
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class GracefulOpen : Addon
local GracefulOpen = Object:extend()

function GracefulOpen:graceful_open()
    if not self.open then
        return false
    end

    if self:is_ready() then
        return false
    end

    repeat
        self:open()
        Wait:fps(5)
    until self:is_ready()

    return true
end

return GracefulOpen
