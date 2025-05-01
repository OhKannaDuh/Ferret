--------------------------------------------------------------------------------
--   DESCRIPTION:
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

require('Ferret/CosmicExploration/PriorityQueue')

---@class CosmicPathfinding : Object
local CosmicPathfinding = Object:extend()
function CosmicPathfinding:new()
    self.average_player_speed = 9.65
    -- self.average_player_walk_speed = 6.2 -- Probably don't need this

    self.aetherytes = {
        -- Moongate Hub
        Node(0.0, 0.0, 0.0),
    }

    self.teleport_cost = 10

    self.cosmoliner_paths = {
        -- Center to North
        CosmolinerPath(Node(4.59, 3.54, -62.13), Node(4.49, 40.89, -377.25), 8.0),
        -- North to Center
        CosmolinerPath(Node(-4.58, 40.55, -378.80), Node(-4.50, 3.83, -63.82), 8.0),
        -- Center to East
        CosmolinerPath(Node(62.25, 3.55, 4.84), Node(377.24, 42.97, 4.50), 9.0),
        -- East to Center
        CosmolinerPath(Node(378.86, 42.54, -4.33), Node(63.86, 3.97, -4.50), 8.0),
        -- Center to South
        CosmolinerPath(Node(-4.45, 3.55, 62.28), Node(-4.51, 37.92, 377.21), 9.0),
        -- South to Center
        CosmolinerPath(Node(3.92, 37.55, 378.70), Node(4.51, 3.93, 63.83), 8.0),
        -- Center to West
        CosmolinerPath(Node(-62.15, 3.54, -4.69), Node(-377.17, 38.99, -4.49), 8.0),
        -- West to Center
        CosmolinerPath(Node(-378.57, 38.55, 4.60), Node(-63.78, 3.90, 4.47), 8.0),
        -- North to Northeast
        CosmolinerPath(Node(22.51, 40.69, -395.53), Node(269.29, 43.44, -316.22), 7.0),
        -- Northeast to east
        CosmolinerPath(Node(306.31, 43.05, -271.85), Node(395.49, 42.95, -22.74), 7.0),
        -- East to Southeast
        CosmolinerPath(Node(395.80, 42.55, 21.30), Node(292.96, 27.70, 260.68), 7.0),
        -- Southeast to South
        CosmolinerPath(Node(261.72, 27.55, 291.87), Node(22.78, 37.98, 395.50), 7.0),
        -- South to Southwest
        CosmolinerPath(Node(-21.27, 37.55, 395.19), Node(-260.67, 32.02, 292.97), 8.0),
        -- Southwest to West
        CosmolinerPath(Node(-291.82, 31.55, 261.72), Node(-395.52, 38.70, 22.78), 7.0),
        -- West to Northwest
        CosmolinerPath(Node(-395.74, 38.55, -21.21), Node(-292.90, 36.70, -260.71), 7.0),
        -- Northwest to North
        CosmolinerPath(Node(-261.84, 36.55, -291.94), Node(-22.77, 40.70, -395.51), 7.0),
        -- North to Northwest
        CosmolinerPath(Node(-21.25, 40.55, -404.45), Node(-267.10, 36.96, -299.23), 7.0),
        -- Northwest to West
        CosmolinerPath(Node(-298.23, 36.55, -268.17), Node(-404.47, 38.96, -22.74), 7.0),
        -- West to Southwest
        CosmolinerPath(Node(-404.41, 38.55, 21.22), Node(-299.28, 31.97, 267.09), 7.0),
        -- Southwest to South
        CosmolinerPath(Node(-268.14, 31.55, 298.49), Node(-22.77, 37.70, 404.50), 7.0),
        -- South to Southeast
        CosmolinerPath(Node(21.44, 37.55, 404.50), Node(267.09, 27.98, 299.32), 7.0),
        -- Southeast to East
        CosmolinerPath(Node(299.02, 27.69, 267.05), Node(404.50, 42.96, 22.77), 8.0),
        -- East to Northeast
        CosmolinerPath(Node(404.49, 42.55, -21.37), Node(314.32, 43.44, -276.50), 7.0),
        -- Northeast to North
        CosmolinerPath(Node(276.69, 43.05, -320.53), Node(22.74, 40.94, -404.49), 8.0),
    }
end

function CosmicPathfinding:pathfind(from, to)
    local path, time = self:create_path(from, to)

    for _, entry in pairs(path) do
        if entry.type == 'start' then
            Logger:debug('Start at: ' .. entry.node:to_formatted_string())
        elseif entry.type == 'cosmoliner_start' then
            Logger:debug('Go to cosmoliner at: ' .. entry.node:to_formatted_string())
        elseif entry.type == 'cosmoliner_finish' then
            Logger:debug('Get off cosmoliner at: ' .. entry.node:to_formatted_string())
        elseif entry.type == 'walk' then
            Logger:debug('Walk to: ' .. entry.node:to_formatted_string())
        elseif entry.type == 'teleport' then
            Logger:debug('Teleport to: ' .. entry.node:to_formatted_string())
        end
    end

    for _, entry in pairs(path) do
        Logger:debug(entry.type)
        if entry.type == 'walk' then
            Pathfinding:walk_to(entry.node)
            Pathfinding:wait_until_at_node(entry.node)
            Pathfinding:stop()
        elseif entry.type == 'cosmoliner_start' then
            Pathfinding:walk_to(entry.node)
            self:wait_until_on_cosmoliner()
            Pathfinding:stop()
        elseif entry.type == 'cosmoliner_finish' then
            self:wait_until_on_cosmoliner()
            self:wait_until_off_cosmoliner()
        elseif entry.type == 'teleport' then
            yield('/ac "Duty Action I"')
            Character:wait_until_not_available(10)
            Character:wait_until_available()
            Ferret:wait(2)
        end
    end
end

-- Still needs work
function CosmicPathfinding:create_path(from, to)
    Logger:debug('Pathfinding from: ' .. from:to_string())
    Logger:debug('              to: ' .. to:to_string())
    -- Helpers
    local function node_id(n)
        return n:to_string()
    end
    local function walk_time(a, b)
        local dx, dy = b.x - a.x, b.y - a.y
        local dz = (b.z or 0) - (a.z or 0)
        return math.sqrt(dx * dx + dy * dy + dz * dz) / self.average_player_speed
    end

    -- Dijkstra structures
    local frontier = PriorityQueue()
    local times, came_from, came_action, came_node = {}, {}, {}, {}
    local visited = {}

    -- Push helper includes action and stores node
    local function push(node, new_time, prev_id, action)
        local id = node_id(node)
        if visited[id] then
            return
        end
        if not times[id] or new_time < times[id] then
            times[id] = new_time
            came_from[id] = prev_id
            came_action[id] = action
            came_node[id] = node
            frontier:push(node, new_time)
        end
    end

    -- Initialize with start node
    push(from, 0, nil, 'start')

    -- Main Dijkstra loop
    while not frontier:empty() do
        local current = frontier:pop()
        local cid = node_id(current)
        if visited[cid] then
            break
        end
        visited[cid] = true
        if current == to then
            break
        end

        local cur_time = times[cid]
        -- 1) Walk directly to destination
        push(to, cur_time + walk_time(current, to), cid, 'walk')

        -- 2) Teleport to aetherytes
        for _, a in ipairs(self.aetherytes) do
            push(a, cur_time + self.teleport_cost, cid, 'teleport')
        end

        -- 3) Cosmoliner paths: walk to start then finish
        for _, path in ipairs(self.cosmoliner_paths) do
            local start = path.start
            local finish = path.finish
            local start_id = node_id(start)
            -- Walk to cosmoliner start
            local wt = walk_time(current, start)
            push(start, cur_time + wt, cid, 'cosmoliner_start')
            -- Traverse cosmoliner to finish
            local tcost = path:cost()
            push(finish, cur_time + wt + tcost, start_id, 'cosmoliner_finish')
        end
    end

    -- Reconstruct best path with single nodes per action
    local path = {}
    local step_id = node_id(to)
    while step_id do
        local node = came_node[step_id]
        local action = came_action[step_id]
        table.insert(path, 1, { node = node, type = action })
        step_id = came_from[step_id]
    end

    return path, times[node_id(to)]
end

function CosmicPathfinding:is_on_cosmoliner()
    return Character:has_condition(Conditions.Mounted)
        and Character:has_condition(Conditions.WatchingCustscene)
        and Character:has_condition(Conditions.Flying)
end

function CosmicPathfinding:is_not_on_cosmoliner()
    return not CosmicPathfinding:is_on_cosmoliner()
end

function CosmicPathfinding:wait_until_on_cosmoliner()
    Ferret:wait_until(self.is_on_cosmoliner, 0.0167)
end

function CosmicPathfinding:wait_until_off_cosmoliner()
    Ferret:wait_until(self.is_not_on_cosmoliner, 0.0167)
end

return CosmicPathfinding()
