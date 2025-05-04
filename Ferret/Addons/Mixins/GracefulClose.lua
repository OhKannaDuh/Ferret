--------------------------------------------------------------------------------
--   DESCRIPTION: Gracefully close
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class GracefulClose : Addon
local GracefulClose = Object:extend()

function GracefulClose:quit()
    self:callback(true, -1)
end

function GracefulClose:graceful_close()
    if not self:is_ready() then
        return false
    end

    repeat
        self:quit()
        Wait:fps(5)
    until not self:is_ready()

    return true
end

return GracefulClose
