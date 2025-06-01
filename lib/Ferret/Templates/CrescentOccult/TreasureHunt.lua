--------------------------------------------------------------------------------
--   DESCRIPTION: Tracks gold per hour
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

Template = require('Ferret/Templates/Template')
CosmicExploration = load_module('CosmicExploration')

---@class TreasureHunt : Template
TreasureHunt = Template:extend()

function TreasureHunt:new()
    TreasureHunt.super.new(self, 'TreasureHunt', Version(2, 9, 0))

    self.bronze = {
        Node(-884.12, 3.80, -682.03),
        Node(-856.96, 68.83, -93.16),
        Node(-784.76, 138.99, 699.76),
        Node(-767.45, 115.62, -235.00),
        Node(-756.83, 76.55, 97.37),
        Node(-729.92, 116.53, -79.06),
        Node(-729.55, 106.98, 561.15),
        Node(-729.43, 4.99, -724.82),
        Node(-716.15, 170.98, 794.43),
        Node(-713.80, 62.06, 192.61),
        Node(-680.54, 104.84, -354.79),
        Node(-676.42, 170.98, 640.38),
        Node(-661.71, 2.98, -579.49),
        Node(-648.00, 75.00, 403.95),
        Node(-600.27, 138.99, 802.64),
        Node(-585.29, 4.99, -864.84),
        Node(-550.13, 106.98, 627.74),
        Node(-491.02, 2.98, -529.59),
        Node(-487.11, 98.53, -205.46),
        Node(-451.68, 2.98, -775.57),
        Node(-444.11, 90.68, 26.23),
        Node(-401.66, 85.04, 332.54),
        Node(-394.89, 106.74, 175.43),
        Node(-372.67, 75.00, 527.43),
        Node(-343.16, 52.32, -382.13),
        Node(-256.89, 120.99, 125.08),
        Node(-225.02, 75.00, 804.99),
        Node(-197.19, 74.91, 618.34),
        Node(-158.65, 98.62, -132.74),
        Node(-140.46, 22.35, -414.27),
        Node(-118.97, 4.99, -708.46),
        Node(-25.68, 102.22, 150.16),
        Node(8.99, 103.20, 426.96),
        Node(35.72, 65.11, 648.95),
        Node(55.28, 111.31, -289.08),
        Node(140.98, 55.99, 770.99),
        Node(142.11, 16.40, -574.06),
        Node(245.59, 109.12, -18.17),
        Node(256.15, 73.17, 492.36),
        Node(277.79, 103.78, 241.90),
        Node(294.88, 56.08, 640.22),
        Node(354.12, 95.66, -288.93),
        Node(381.73, 22.17, -743.65),
        Node(386.92, 96.79, -451.38),
        Node(433.71, 70.30, 683.53),
        Node(471.18, 70.30, 530.02),
        Node(475.73, 95.99, -87.08),
        Node(490.41, 62.46, -590.57),
        Node(524.50, -489.01, 55.38),
        Node(550.44, -489.01, -114.79),
        Node(596.46, 70.30, 622.77),
        Node(609.61, 107.99, 117.27),
        Node(617.09, 66.30, -703.88),
        Node(642.97, 69.99, 407.80),
        Node(666.53, 79.12, -480.37),
        Node(726.28, 108.14, -67.92),
        Node(779.02, 96.09, -256.24),
        Node(788.88, 120.38, 109.39),
        Node(826.69, 122.00, 434.99),
        Node(835.08, 69.99, 699.09),
        Node(869.29, 109.97, 581.20),
        Node(870.66, 95.69, -388.36),
    }

    self.silver = {
        Node(-825.16, 2.98, -832.27),
        Node(-798.25, 105.58, -310.57),
        Node(-682.80, 135.61, -195.27),
        Node(-645.69, 202.99, 710.17),
        Node(-283.99, 115.98, 377.04),
        Node(517.75, 67.89, 236.13),
        Node(697.32, 69.99, 597.92),
        Node(699.98, -459.86, 265.22),
        Node(770.75, 107.99, -143.57),
    }

    self.include_bronze = true
    self.include_silver = true

    self.unsorted_nodes = {}
    self.sorted_nodes = {}

    self.pathfinding = Pathfinding()
end

function TreasureHunt:init()
    Template.init(self)

    return self
end

function TreasureHunt:setup()
    if self.include_bronze then
        for _, node in ipairs(self.bronze) do
            table.insert(self.unsorted_nodes, node)
        end
    end

    if self.include_silver then
        for _, node in ipairs(self.silver) do
            table.insert(self.unsorted_nodes, node)
        end
    end

    self.sorted_nodes = self:sort(self.unsorted_nodes)
    for _, node in ipairs(self.sorted_nodes) do
        self.pathfinding:add_node(node)
    end

    return true
end

function TreasureHunt:sort(input)
    local path = {}
    local visited = {}
    local current = Character:get_position()

    while #visited < #input do
        local nearest = nil
        local nearest_index = nil
        local nearest_distance = math.huge

        for i, node in ipairs(input) do
            if not visited[i] then
                -- local dist = distance(current, node)
                local dist = current:get_distance_to(node)
                if dist < nearest_distance then
                    nearest_distance = dist
                    nearest = node
                    nearest_index = i
                end
            end
        end

        table.insert(path, nearest)
        visited[nearest_index] = true
        current = nearest
    end

    return path
end

function TreasureHunt:loop()
    local node = self.pathfinding:next()

    self.pathfinding:walk_to(node)
    self.pathfinding:wait_until_at_node(node)

    self.pathfinding:stop()

    Wait:seconds(0.3)
end

return TreasureHunt():init()
