--------------------------------------------------------------------------------
--   DESCRIPTION: CosmicExploration all missions
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@type MissionList
local list = MissionList()

local function add_master_mission_list(zone, job)
    local missions = module_require('CosmicExploration', 'Data/Missions/' .. zone .. '/' .. job .. 'Missions.gen.lua')
    for k, v in pairs(missions) do
        list.missions[k] = v
    end
end

local zones = { 'SinusArdorum' }

local jobs = {
    'Carpenter',
    'Blacksmith',
    'Armorer',
    'Goldsmith',
    'Leatherworker',
    'Weaver',
    'Alchemist',
    'Culinarian',
    'Miner',
    'Botanist',
    'Fisher',
    'Critical',
}

for _, zone in pairs(zones) do
    for _, job in pairs(jobs) do
        add_master_mission_list(zone, job)
    end
end

return list
