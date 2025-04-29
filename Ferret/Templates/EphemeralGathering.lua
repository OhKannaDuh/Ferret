--------------------------------------------------------------------------------
--   DESCRIPTION: EphemeralGathering
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

require('Ferret/Ferret')

---@class EphemeralGathering : Ferret
---@field item string|nil
---@field gearset string|nil
---@field starting_node Node|nil
---@field start_time integer
---@field end_time integer
EphemeralGathering = Ferret:extend()
function EphemeralGathering:new()
    EphemeralGathering.super.new(self, i18n('templates.ephemeral_gathering.name'))
    self.template_version = Version(0, 1, 0)

    self.item = nil
    self.gearset = nil
    self.starting_node = nil
    self.start_time = -1
    self.end_time = -1
end

function EphemeralGathering:prep()
    if Gathering:get_gp() >= 900 then
        if Gathering:get_gp() >= 900 then
            Character:action('Priming Touch')
        end

        Character:action('Scrutiny')
        Gathering:meticulous_action()

        Character:action('Priming Touch')
        Character:action('Scrutiny')
        Gathering:meticulous_action()

        if Gathering:collectability() >= 1000 then
            return
        end

        if Gathering:collectability() >= 850 then
            Gathering:meticulous_action()
            return
        end

        Character:action('Scour')
        if Gathering:collectability() < 1000 then
            Gathering:meticulous_action()
        end
    else
        -- This should get us to at least 400 collectability
        Character:action('Scour')
        if Gathering:collectability() >= 250 or Gathering:has_collectors_standard() then
            Gathering:meticulous_action()
            if Gathering:collectability() < 400 then
                Gathering:meticulous_action()
            end

            return
        end

        Character:action('Scour')
    end
end

function EphemeralGathering:collect()
    if Gathering:collectability() >= 1000 then
        while Gathering:get_integrity() > 0 and Gathering:is_gathering_collectable() do
            -- if self:hasRevisit() then
            --     return self:revisit()
            -- end

            if Gathering:integrity() <= 3 then
                Gathering:integrity_action()
            end

            Character:action('Collect')
        end
    else
        while Gathering:get_integrity() > 0 and Gathering:is_gathering_collectable() do
            -- if self:hasRevisit() then
            --     return self:revisit()
            -- end

            Character:action('Collect')
        end
    end
end

function EphemeralGathering:setup()
    Logger:info(self.name .. ': ' .. self.template_version:to_string())

    Character:wait_until_available()

    if self.gearset ~= nil then
        yield('/gearset change ' .. self.gearset)
    end

    if self.item ~= nil then
        GatherBuddy:gather(self.item)
    end

    if not Mount:is_mounted() then
        Mount:mount()
    end

    local first = self.starting_node
    if first == nil then
        first = Pathfinding:next()
        Pathfinding.index = 0
    end

    Pathfinding:fly_to(first)
    Pathfinding:wait_until_at_node(first)

    return true
end

function EphemeralGathering:loop()
    if not World:is_hour_between(self.start_time, self.end_time) then
        World:wait_until(self.start_time)
    end

    local node = Pathfinding:next()
    if node == nil then
        Logger:warn('templates.emphemeral_gathering.no_node')
        self:stop()
        return
    end

    Ferret:wait(2)

    Pathfinding:fly_to(node)
    if not Mount:is_mounted() then
        Mount:mount()
    end

    Gathering:wait_for_nearby_nodes()
    local nearest = Targetable(Gathering:get_nearest_node())
    nearest:target()

    Pathfinding:stop()
    local target = Character:get_target_position()
    local floor = Pathfinding:get_floor_near_node(target)

    Pathfinding:move_to(floor)
    Gathering:wait_to_start(10)
    if not Gathering:is_gathering() then
        Pathfinding:move_to(target)
        Gathering:wait_to_start()
    end

    Pathfinding:stop()
    if not Gathering:is_gathering() then
        return
    end

    Gathering:wait_to_start_collectable()
    self:prep()
    self:collect()
    Gathering:wait_to_stop_collectable()
    Ferret:wait(1)
end

local ferret = EphemeralGathering()
Ferret = ferret

return ferret
