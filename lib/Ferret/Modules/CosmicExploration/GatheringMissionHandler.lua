--------------------------------------------------------------------------------
--   DESCRIPTION: Handler for doing gathering missions
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class GatheringMissionHandler : Object
local GatheringMissionHandler = Object:extend()

function GatheringMissionHandler:handle(mission, goal)
    self.pathfinding = Pathfinding()

    if mission.gathering_node_layout == GatheringNodeLayout.Unknown then
        return
    end

    local origin = Character:get_position()
    if mission.gathering_node_layout == GatheringNodeLayout.Chain then
        local nodes = {}

        for _, chain_end in ipairs(mission.chain_ends) do
            local distance = origin:get_distance_to(chain_end)
            table.insert(nodes, { node = chain_end, distance = distance })
        end

        table.sort(nodes, function(a, b)
            return a.distance < b.distance
        end)

        for _, node in ipairs(nodes) do
            self.pathfinding:add_node(node.node)
        end

        self:walk_to_start()
        return self:chain(mission, goal)
    end

    if mission.gathering_node_layout == GatheringNodeLayout.Clustered then
        local closest_index = 1
        local closest_distance = math.huge

        for i = 1, #mission.clusters do
            local dist = origin:get_distance_to(mission.clusters[i])
            if dist < closest_distance then
                closest_index = i
                closest_distance = dist
            end
        end

        local ordered_clusters = {}
        for i = closest_index, #mission.clusters do
            table.insert(ordered_clusters, mission.clusters[i])
        end
        for i = 1, closest_index - 1 do
            table.insert(ordered_clusters, mission.clusters[i])
        end

        for _, node in ipairs(ordered_clusters) do
            self.pathfinding:add_node(node)
        end

        return self:clustered(mission, goal)
    end
end

function GatheringMissionHandler:walk_to_start()
    self.pathfinding:reset()

    local start = self.pathfinding:next()
    self.pathfinding:walk_to(start)
    self.pathfinding:wait_until_at_node(start)
    self.pathfinding:stop()
    self.pathfinding:reset()
end

function GatheringMissionHandler:chain(mission, goal)
    mission:start()
    Addons.WKSMissionInfomation:graceful_open()

    repeat
        local nearest = Gathering:get_nearest_node()
        nearest:target()

        local node = Character:get_target_position()
        self.pathfinding:walk_to(node)

        repeat
            Wait:fps(5)
            nearest:interact()
        until Gathering:is_gathering()

        Gathering:wait_to_start()
        self.pathfinding:stop()

        Addons.Gathering:wait_until_ready()
        Wait:seconds(0.5)
        local items = Addons.Gathering:get_items()

        repeat
            local index = self:get_index(mission, items)

            GatheringMissionRotationHandler:handle(mission, index)

            Character:wait_until_ready_to_gather()
        until not Gathering:is_gathering()

        Gathering:wait_to_stop()
    until Addons.ToDoList:get_stellar_mission_scores().tier >= goal
    Wait:seconds(1)
    mission:finish(goal)
end

function GatheringMissionHandler:gather_cluster(mission)
    repeat
        local nearest = Gathering:get_nearest_node()
        nearest:target()

        local node = Character:get_target_position()
        self.pathfinding:walk_to(node)

        repeat
            Wait:fps(5)
            nearest:interact()
        until Gathering:is_gathering()

        Gathering:wait_to_start()
        self.pathfinding:stop()

        Addons.Gathering:wait_until_ready()
        Wait:seconds(0.5)
        local items = Addons.Gathering:get_items()

        repeat
            local index = self:get_index(mission, items)

            GatheringMissionRotationHandler:handle(mission, index)

            Character:wait_until_ready_to_gather()
        until not Gathering:is_gathering()
    until not Gathering:has_nearby_nodes(20)
end

function GatheringMissionHandler:clustered(mission, goal)
    mission:start()
    Addons.WKSMissionInfomation:graceful_open()

    repeat
        local cluster_location = self.pathfinding:next()
        Logger:info('Moving to cluster: ' .. cluster_location:to_string())
        self.pathfinding:walk_to(cluster_location)
        self.pathfinding:wait_until_at_node(cluster_location)
        self.pathfinding:stop()
        Logger:info('Cluster reached')

        Logger:info('Gathering from cluster')
        self:gather_cluster(mission)
        Logger:info('Cluster depleated')

        Wait:seconds(0.5)
    until Addons.WKSMissionInfomation:get_time_limit_label() == 'Clear Time'

    Wait:seconds(1)
    mission:finish(goal)
end

function GatheringMissionHandler:get_index(mission, items)
    local index = -1
    for id, config in pairs(mission.gathering_config) do
        local item_id = tonumber(id)
        local count = GetItemCount(item_id)

        if count < config.amount then
            for _, item_data in pairs(items) do
                if config.name == item_data.item then
                    index = item_data.index
                    break
                end
            end
        end

        if index ~= ~1 then
            break
        end
    end

    if index == -1 then
        Logger:table(items)
        index = Table:first(items).index
    end

    return index
end

return GatheringMissionHandler()
