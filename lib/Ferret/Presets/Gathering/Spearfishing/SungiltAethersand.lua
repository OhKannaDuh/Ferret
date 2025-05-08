local ferret = require('Ferret/Templates/Gathering/Spearfishing')
require('Ferret/Extensions/AethericReduction')

ferret.name = 'Sungilt Aethersand'
ferret.fish = 'Sunlit Prism'

ferret.pathfinding:add_node(Node(301.4, -35.2, -851.3))
ferret.pathfinding:add_node(Node(369.8, -50.3, -741.4))
ferret.pathfinding:add_node(Node(420.4, -53.8, -909.2))

return ferret
