--------------------------------------------------------------------------------
--   DESCRIPTION: A timer, for tracking how much time has elapsed
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Timer : Object
Timer = Object:extend()
function Timer:new()
    self.startTime = nil
end

--- Sets the timers start point to the current time
function Timer:start()
    self.startTime = os.time()
end

---
---@return integer #Gets the number of seconds passed since this timer was started, or 0 if it hasn't been started
function Timer:seconds()
    if self.startTime == nil then
        return 0
    end

    return os.difftime(os.time(), self.startTime)
end
