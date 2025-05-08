--------------------------------------------------------------------------------
--   DESCRIPTION: CosmicExploration all missions
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

require('Ferret/CosmicExploration/Data/Mission')
require('Ferret/CosmicExploration/Data/MissionList')
require('Ferret/Data/Name')

---@type MissionList
MasterMissionList = MissionList()

local function add_master_mission_list(zone, job)
    local missions = require('Ferret/CosmicExploration/Data/Missions/' .. zone .. '/' .. job .. 'Missions.gen')
    for k, v in pairs(missions) do
        MasterMissionList.missions[k] = v
    end
end

add_master_mission_list('SinusArdorum', 'Carpenter')
add_master_mission_list('SinusArdorum', 'Blacksmith')
add_master_mission_list('SinusArdorum', 'Armorer')
add_master_mission_list('SinusArdorum', 'Goldsmith')
add_master_mission_list('SinusArdorum', 'Leatherworker')
add_master_mission_list('SinusArdorum', 'Weaver')
add_master_mission_list('SinusArdorum', 'Alchemist')
add_master_mission_list('SinusArdorum', 'Culinarian')
add_master_mission_list('SinusArdorum', 'Miner')
add_master_mission_list('SinusArdorum', 'Botanist')
add_master_mission_list('SinusArdorum', 'Fisher')
