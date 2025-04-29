local ferret = require('Ferret/Templates/EphemeralGathering')

ferret.name = 'Mythloam Aethersand'

ferret.item = 'Brightwind Ore'
ferret.gearset = 'Miner'
ferret.starting_node = Node(-547.4, 8.2, -518.1)
ferret.start_time = 0
ferret.end_time = 4

Gathering.node_nodes = {
    'Ephemeral Rocky Outcrop',
}

Pathfinding:add_node(Node(-555.6, -7.7, -648.1))
Pathfinding:add_node(Node(-687.6, -4.0, -473.1))
Pathfinding:add_node(Node(-403.3, -5.0, -439.0))

return ferret
