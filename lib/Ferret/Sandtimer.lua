--------------------------------------------------------------------------------
--   DESCRIPTION: A sandtimer
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Sandtimer : Timer
Sandtimer = Timer:extend()
function Sandtimer:new(max)
    Sandtimer.super.new(self)
    self.max = max
end

function Sandtimer:flip()
    self:start()
end

function Sandtimer:has_run_out()
    return self:seconds() >= self.max
end
