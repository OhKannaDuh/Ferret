--------------------------------------------------------------------------------
--   DESCRIPTION: Handler for doing crafting missions
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class GatheringMissionHandler : Object
local GatheringMissionHandler = Object:extend()

function GatheringMissionHandler:handle(mission, goal)
    if mission.gathering_node_layout == GatheringNodeLayout.Unknown then
        return
    end

    self:walk_to_start(mission)

    if mission.gathering_node_layout == GatheringNodeLayout.Chain then
        return self:chain(mission, goal)
    end

    if mission.gathering_node_layout == GatheringNodeLayout.Clustered then
        return self:clustered(mission, goal)
    end
end

function GatheringMissionHandler:walk_to_start(mission)
    mission.pathfinding:reset()

    local start = mission.pathfinding:next()
    mission.pathfinding:walk_to(start)
    mission.pathfinding:wait_until_at_node(start)
    mission.pathfinding:stop()
    mission.pathfinding:reset()
end

function GatheringMissionHandler:chain(mission, goal)
    mission:start()
    Addons.WKSMissionInfomation:graceful_open()

    repeat
        Logger:debug('Getting nearest node name')
        local nearest = Gathering:get_nearest_node()
        Logger:debug('Targetting: ' .. (nearest.name or 'unk'))
        nearest:target()

        Logger:debug('Getting nearest node position')
        local node = Character:get_target_position()
        Logger:debug('Walking to node ' .. node:to_string())
        mission.pathfinding:walk_to(node)
        Logger:debug('Waiting to start gathering')

        Gathering:wait_to_start()
        Logger:debug('Stopping pathfinder')
        mission.pathfinding:stop()
        Logger:debug('Waiting to stop gathering')
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
        mission.pathfinding:walk_to(node)
        Gathering:wait_to_start()
        mission.pathfinding:stop()
        Gathering:wait_to_stop()
        Wait:seconds(0.5)
    until not Gathering:has_nearby_nodes(20)
end

function GatheringMissionHandler:clustered(mission, goal)
    mission:start()
    Addons.WKSMissionInfomation:graceful_open()

    repeat
        local cluster_location = mission.pathfinding:next()
        Logger:info('Moving to cluster: ' .. cluster_location:to_string())
        mission.pathfinding:walk_to(cluster_location)
        mission.pathfinding:wait_until_at_node(cluster_location)
        mission.pathfinding:stop()
        Logger:info('Cluster reached')

        Logger:info('Gathering from cluster')
        self:gather_cluster(mission)
        Logger:info('Cluster depleated')

        Wait:seconds(0.5)
    until Addons.WKSMissionInfomation:get_time_limit_label() == 'Clear Time'

    Wait:seconds(1)
    mission:finish(goal)
end

return GatheringMissionHandler()
