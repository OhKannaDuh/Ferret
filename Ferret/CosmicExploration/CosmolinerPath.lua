--------------------------------------------------------------------------------
--   DESCRIPTION: Cosmoliner path
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class CosmolinerPath : Object
---@field start Node
---@field finish Node
---@field time number
CosmolinerPath = Object:extend()
function CosmolinerPath:new(start, finish, time)
    self.start = start
    self.finish = finish
    self.time = time
end

function CosmolinerPath:distance()
    return math.sqrt((self.finish.x - self.start.x) ^ 2 + (self.finish.y - self.start.y) ^ 2)
end

function CosmolinerPath:cost()
    return self:distance() / self.time
end
