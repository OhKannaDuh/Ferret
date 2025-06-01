--------------------------------------------------------------------------------
--   DESCRIPTION: Class to help with pathfinding using vnavmesh
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Pathfinding : Object
---@field nodes Node[]
---@field index integer
---@field distance_for_sprint integer
Pathfinding = Object:extend()
function Pathfinding:new()
    self.nodes = {}
    self.index = 0
    self.distance_for_sprint = 500
end

---@param node Node
function Pathfinding:add_node(node)
    table.insert(self.nodes, node)
end

---@return integer
function Pathfinding:count()
    return Table:count(self.nodes)
end

---@param index integer
---@return Node|nil
function Pathfinding:get(index)
    return self.nodes[index]
end

---@return Node|nil
function Pathfinding:current()
    return self:get(self.index)
end

---@return Node|nil
function Pathfinding:next()
    local count = self:count()
    if count <= 0 then
        return nil
    end

    self.index = self.index + 1
    if self.index > count then
        self.index = 1
    end

    return self:current()
end

---@return integer
function Pathfinding:distance()
    local node = self:current()
    if not node then
        return math.maxinteger
    end

    return GetDistanceToPoint(node.x, node.y, node.z)
end

---@param node Node?
function Pathfinding:fly_to(node)
    node = node or self:current()
    if node == nil then
        return
    end

    if not Mount:is_mounted() then
        self:walk_to(node)
        Mount:mount()

        Wait:tps_until(Mount, Mount.is_mounted, 5, 5)
    end

    yield('/vnavmesh flyto ' .. node.x .. ' ' .. node.y .. ' ' .. node.z)
end

---@param node Node?
function Pathfinding:walk_to(node)
    node = node or self:current()
    if node == nil then
        return
    end

    if self:distance() >= self.distance_for_sprint then
        Actions.Sprint:execute()
    end

    yield('/vnavmesh moveto ' .. node.x .. ' ' .. node.y .. ' ' .. node.z)
end

---@param node Node?
function Pathfinding:move_to(node)
    node = node or self:current()

    -- If is flying then self:fly_to(node)

    self:walk_to(node)
end

function Pathfinding:fly_to_flag()
    yield('/vnavmesh flyflag')
end

function Pathfinding:walk_to_flag()
    if self:distance() >= self.distance_for_sprint then
        Actions.Sprint:execute()
    end

    yield('/vnavmesh moveflag')
end

function Pathfinding:move_to_flag()
    -- If is flying then self:fly_to_flag(node)

    self:walk_to_flag()
end

function Pathfinding:stop()
    yield('/vnavmesh stop')
end

function Pathfinding:wait_to_start_moving()
    Wait:seconds_until(Character, Character.is_moving)
end

function Pathfinding:wait_to_stop_moving()
    Wait:seconds_until(Character, Character.is_not_moving)
end

function Pathfinding:wait_until_at_node(node)
    node = node or Pathfinding:current()

    if Character:get_position():is_nearby(node, 1) then
        return
    end

    repeat
        Wait:fps(60)
    until Character:get_position():is_nearby(node, 1)
end

function Pathfinding:wait_until_close_to_target(distance)
    if Character:get_target_position():get_distance_to() <= distance then
        return
    end

    repeat
        Wait:seconds(0.1)
    until Character:get_target_position():get_distance_to() <= distance
end

---@param node Node
function Pathfinding:get_floor_near_node(node)
    local fx = nil
    local fy = nil
    local fz = nil
    local i = 0

    while not fx or not fy or not fz do
        fx = QueryMeshPointOnFloorX(node.x, node.y, node.z, false, i)
        fy = QueryMeshPointOnFloorY(node.x, node.y, node.z, false, i)
        fz = QueryMeshPointOnFloorZ(node.x, node.y, node.z, false, i)
        i = i + 1
    end

    return Node(fx, fy, fz)
end

function Pathfinding:reset()
    self.index = 0
end
