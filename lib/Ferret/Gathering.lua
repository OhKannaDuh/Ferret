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

function Gathering:is_gathering_collectable()
    return Addons.GatheringMasterpiece:is_ready()
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
    Ferret:wait_until(function()
        return self:is_gathering()
    end, nil, max)
end

function Gathering:wait_to_stop()
    Ferret:wait_until(function()
        return not self:is_gathering()
    end)
end

function Gathering:wait_to_start_collectable()
    Ferret:wait_until(function()
        return self:is_gathering_collectable()
    end)
end

function Gathering:wait_to_stop_collectable()
    Ferret:wait_until(function()
        return not self:is_gathering_collectable()
    end)
end

function Gathering:is_valid_node_name(name)
    return Table:contains(self.node_names, name)
end

---@return string[]
function Gathering:get_nearby_nodes()
    local list = GetNearbyObjectNames(self.scan_range, Objects.GatheringPoint)
    local nodes = {}

    for i = 0, list.Count - 1 do
        table.insert(nodes, list[i])
    end

    return nodes
end

---@return string|nil
function Gathering:get_nearest_node()
    return Table:first(self:get_nearby_nodes())
end

---@return boolean
function Gathering:has_nearby_nodes()
    return not Table:is_empty(self:get_nearby_nodes())
end

function Gathering:wait_for_nearby_nodes()
    Ferret:wait_until(function()
        return self:has_nearby_nodes()
    end)
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

return Gathering()
