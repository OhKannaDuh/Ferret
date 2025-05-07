--------------------------------------------------------------------------------
--   DESCRIPTION: Spearfishing
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

Template = require('Ferret/Templates/Template')

---@class Spearfishing : Template
---@field node Targetable
---@field agpreset string|nil
---@field fish string|nil
---@field starting_node Node|nil
Spearfishing = Template:extend()

function Spearfishing:new()
    Spearfishing.super.new(self, 'spearfishing', Version(0, 2, 0))

    self.node = Targetable(i18n('nodes.teeming_waters'))
    self.agpreset = nil
    self.fish = nil
    self.starting_node = nil
end

function Spearfishing:setup()
    Character:wait_until_available()
    if self.agpreset ~= nil then
        yield('/agpreset ' .. self.agpreset)
    end

    if self.fish ~= nil then
        GatherBuddy:gather_fish(self.fish)
    end

    Mount:mount()

    local first = self.starting_node
    if first == nil then
        first = Pathfinding:next()
        Pathfinding.index = 0
    end

    Pathfinding:fly_to(first)
    Pathfinding:wait_until_at_node(first)

    return true
end

function Spearfishing:loop()
    local node = Pathfinding:next()
    if node == nil then
        self:log_warn('no_node')
        self:stop()
        return
    end

    if not Mount:is_mounted() then
        Mount:mount()
    end

    Pathfinding:fly_to(node)

    Character:wait_for_target(self.node)

    Pathfinding:fly_to(Character:get_target_position())

    Addons.SpearFishing:wait_until_ready()
    Wait:seconds(1)
    Addons.SpearFishing:wait_until_not_ready()

    Pathfinding:stop()
    Pathfinding:wait_to_stop_moving()
    Wait:seconds(1)
end

return Spearfishing():init()
