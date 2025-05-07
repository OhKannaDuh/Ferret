_name = "Point Farm"
local ferret = require('Ferret/Templates/CosmicExploration/MissionFarmer')


ferret.mission_list = CosmicExploration:create_mission_list_from_ids({
    31,  32,  40,  34,  25,  24,  33,  26,  -- CRP
    76,  77,  85,  79,  70,  69,  78,  71,  -- BSM
    121, 122, 130, 124, 115, 114, 123, 116, -- ARM
    166, 167, 175, 169, 160, 159, 168, 161, -- GSM
    211, 212, 220, 214, 205, 204, 213, 206, -- LTW
    256, 257, 265, 259, 250, 249, 258, 251, -- WVR
    301, 302, 310, 304, 295, 294, 303, 296, -- ALC
    346, 347, 355, 349, 340, 339, 348, 341, -- CUL
})
  
CosmicExploration.per_mission_target_result = {
    [31] = MissionResult.Silver, -- CRP
    [32] = MissionResult.Silver,
    [76] = MissionResult.Silver, -- BSM
    [77] = MissionResult.Silver,
    [121] = MissionResult.Silver, -- ARM
    [122] = MissionResult.Silver,
    [166] = MissionResult.Silver, -- GSM
    [167] = MissionResult.Silver,
    [211] = MissionResult.Silver, -- LTW
    [212] = MissionResult.Silver,
    [256] = MissionResult.Silver, -- WVR
    [257] = MissionResult.Silver,
    [301] = MissionResult.Silver, -- ALC
    [302] = MissionResult.Silver,
    [346] = MissionResult.Silver, -- CUL
    [347] = MissionResult.Silver,
}

return ferret
