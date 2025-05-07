--------------------------------------------------------------------------------
--   DESCRIPTION: A class representing a node in 3d space, x, y, z
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Node : Object
---@field x integer
---@field y integer
---@field z integer
Node = Object:extend()

---@param x integer
---@param y integer
---@param z integer
function Node:new(x, y, z)
    self.x = x
    self.y = y
    self.z = z
end

---@param distance? integer
---@return Node
function Node:get_random_nearby(distance)
    distance = distance or 0.5

    local dx = math.random(-distance, distance)
    local dy = math.random(-distance, distance)
    local dz = math.random(-distance, distance)

    return Node(self.x + dx, self.y + dy, self.z + dz)
end

---@param distance? integer
---@return Node
function Node:get_random_nearby_xz(distance)
    distance = distance or 0.5

    local dx = math.random(-distance, distance)
    local dz = math.random(-distance, distance)

    return Node(self.x + dx, self.y, self.z + dz)
end

---@param other Node
---@return number
function Node:get_distance_to(other)
    other = other or Character:get_position()

    local dx = self.x - other.x
    local dy = self.y - other.y
    local dz = self.z - other.z

    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

---@param other Node
---@param max? number
---@return boolean
function Node:is_nearby(other, max)
    max = max or 0.5

    local distance = self:get_distance_to(other)

    return distance <= (max * max)
end

function Node:to_string()
    return string.format('%f, %f, %f', self.x, self.y, self.z)
end
