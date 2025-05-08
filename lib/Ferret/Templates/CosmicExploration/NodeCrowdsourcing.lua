--------------------------------------------------------------------------------
--   DESCRIPTION: NodeCrowdsourcing
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

Template = require('Ferret/Templates/Template')
require('Ferret/CosmicExploration/Library')

---@class NodeCrowdsourcing : Template
---@field item string|nil
---@field starting_node Node|nil
---@field start_time integer
---@field end_time integer
NodeCrowdsourcing = Template:extend()
function NodeCrowdsourcing:new()
    NodeCrowdsourcing.super.new(self, 'node_crowdsourcing', Version(0, 1, 0))
    self.name = 'Node Crowdsourcing'
end

function NodeCrowdsourcing:setup()
    if not Logger.log_file_directory then
        return
    end

    return true
end

function NodeCrowdsourcing:is_in_mission()
    return Addons.ToDoList:get_stellar_mission_name() ~= nil
end

function NodeCrowdsourcing:loop()
    Logger:log('Waiting for mission to start')

    local name = Addons.ToDoList:get_stellar_mission_name()
    while name == nil do
        name = Addons.ToDoList:get_stellar_mission_name()
    end

    Logger:log('Mission: ' .. name)

    local data = {}

    local nodes = {}
    local function has_node(node)
        for _, existing_node in ipairs(nodes) do
            if existing_node.x == node.x and existing_node.y == node.y and existing_node.z == node.z then
                return true
            end
        end

        return false
    end

    while self:is_in_mission() do
        Ferret:wait_until(function()
            return Character:has_target() or not self:is_in_mission()
        end, 0.167)

        if Character:has_target() then
            local target = Character:get_target_position()
            if not has_node(target) then
                table.insert(nodes, target)
                local position = Character:get_position()
                table.insert(data, { target, position })
                Logger:log('  - ' .. target:to_string() .. '(' .. position:to_string() .. ')')
            end
        end
    end

    Logger:log('Mission Complete.')
    Logger:log('"' .. name .. '": {')
    Logger:log('  "nodes": [')
    for _, entry in ipairs(data) do
        local target, player = entry[1], entry[2]
        Logger:log('    {')
        Logger:log('      "target_node": [' .. target:to_string() .. '],')
        Logger:log('      "player_node": [' .. player:to_string() .. '],')
        Logger:log('    },')
    end
    Logger:log('  ],')
    Logger:log('},')

    Wait:wait(5)
end

return NodeCrowdsourcing():init()
