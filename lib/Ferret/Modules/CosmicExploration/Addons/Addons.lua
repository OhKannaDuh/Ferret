--------------------------------------------------------------------------------
--   DESCRIPTION: CosmicExploration Addons list
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

local module = 'CosmicExploration'

local function load_module_addon(Addon)
    return module_require(module, 'Addons/' .. Addon)
end

return {
    WKSHud = load_module_addon('WKSHud'),
    WKSMission = load_module_addon('WKSMission'),
    WKSMissionInfomation = load_module_addon('WKSMissionInfomation'),
    WKSRecipeNotebook = load_module_addon('WKSRecipeNotebook'),
    WKSToolCustomize = load_module_addon('WKSToolCustomize'),
}
