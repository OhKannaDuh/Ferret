--------------------------------------------------------------------------------
--   DESCRIPTION: Gathering helper class
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Gathering : Object
---@field scan_range integer
---@field node_names string[]
local Gathering = Object:extend()

function Gathering:new()
    self.scan_range = 2048
    self.node_names = {}
end

function Gathering:is_gathering()
    return Character:has_condition(Conditions.Gathering)
end

function Gathering:is_not_gathering()
    return not self:is_gathering()
end

function Gathering:is_gathering_collectable()
    return Addons.GatheringMasterpiece:is_ready()
end

function Gathering:is_not_gathering_collectable()
    return not self:is_gathering_collectable()
end

function Gathering:get_integrity()
    if Addons.GatheringMasterpiece:is_visible() then
        return Addons.GatheringMasterpiece:get_integrity()
    end

    if Addons.Gathering:is_visible() then
        return Addons.Gathering:get_integrity()
    end

    return 0
end

---@return boolean
function Gathering:has_eureka_moment()
    return Character:has_status(Status.EurekaMoment)
end

function Gathering:wait_to_start(max)
    Wait:seconds_until(self, self.is_gathering, 0.0167, max)
end

function Gathering:wait_to_stop(max)
    Wait:seconds_until(self, self.is_not_gathering, 0.0167, max)
end

function Gathering:wait_to_start_collectable()
    Wait:seconds_until(self, self.is_gathering_collectable)
end

function Gathering:wait_to_stop_collectable()
    Wait:seconds_until(self, self.is_not_gathering_collectable)
end

function Gathering:is_valid_node_name(name)
    return Table:contains(self.node_names, name)
end

---@return string[]
function Gathering:get_nearby_nodes(range)
    local list = GetNearbyObjectNames(range or self.scan_range, Objects.GatheringPoint)
    local nodes = {}

    for i = 0, list.Count - 1 do
        table.insert(nodes, list[i])
    end

    return nodes
end

---@return string|nil
function Gathering:get_nearest_node(range)
    return Targetable(Table:first(self:get_nearby_nodes(range)))
end

---@return boolean
function Gathering:has_nearby_nodes(range)
    return not Table:is_empty(self:get_nearby_nodes(range))
end

function Gathering:wait_for_nearby_nodes()
    Wait:seconds_until(self, self.has_nearby_nodes)
end

---@return boolean
function Gathering:has_collectors_standard()
    return Character:has_status({ Status.CollectorsHighStandard, Status.CollectorsStandard })
end

---@return boolean
function Gathering:is_botanist()
    return GetClassJobId() == Jobs.Botanist
end

---@return boolean
function Gathering:is_miner()
    return GetClassJobId() == Jobs.Miner
end

---@return boolean
function Gathering:is_fisher()
    return GetClassJobId() == Jobs.Fisher
end

---@return integer
function Gathering:get_gp()
    return GetGp()
end

---@return integer
function Gathering:get_max_gp()
    return GetMaxGp()
end

function Gathering:meticulous_action()
    if self:is_botanist() then
        Actions.MeticulousWoodsman:execute()
    end

    if self:is_miner() then
        Actions.MeticulouProspector:execute()
    end
end

function Gathering:integrity_action()
    if self:has_eureka_moment() then
        return Actions.WiseToTheWorld:execute()
    end

    if self:is_botanist() then
        Actions.AgelessWords:execute()
    end

    if self:is_miner() then
        Actions.SolidReason:execute()
    end
end

function Gathering:is_executing_gathering_action()
    return Character:has_condition(Conditions.ExecutingGatheringAction)
end

function Gathering:is_not_executing_gathering_action()
    return not self:is_executing_gathering_action()
end

function Gathering:wait_to_start_action()
    Wait:seconds_until(self, self.is_executing_gathering_action, 0.1)
end

function Gathering:wait_to_stop_action()
    Wait:seconds_until(self, self.is_not_executing_gathering_action, 0.1)
end

function Gathering:execute(action)
    Logger:debug('Executing gathering action: ' .. action)
    local cost = GatheringActionCosts[action]
    if cost > self:get_gp() then
        return false
    end

    ExecuteAction(GatheringActions[GetClassJobId()][action])
    Gathering:wait_to_start_action()
    Gathering:wait_to_stop_action()
    Wait:seconds(0.5)

    return true
end

function Gathering:gather(index)
    Addons.Gathering:gather(index)
    Gathering:wait_to_start_action()
    Gathering:wait_to_stop_action()
end

function Gathering:start_collect(index)
    Addons.Gathering:gather(index)
    Addons.GatheringMasterpiece:wait_until_ready()
end

function Gathering:is_ready_to_execute_action()
    return not Character:has_condition(Conditions.Gathering42)
end

function Gathering:wait_until_ready_to_gather()
    Wait:seconds_until(self, self.is_ready_to_execute_action, 0.1)
end

return Gathering()
