require('Ferret/Actions/Action')

local function require_action(name)
    return require('Ferret/Actions/' .. name)
end

Actions = {
    AetherialReduction = require_action('AetherialReduction'),
    AgelessWords = require_action('AgelessWords'),
    CraftingLog = require_action('CraftingLog'),
    MateriaExtraction = require_action('MateriaExtraction'),
    MeticulouProspector = require_action('MeticulouProspector'),
    MeticulousWoodsman = require_action('MeticulousWoodsman'),
    Mount = require_action('MountAction'),
    MountRoulette = require_action('MountRoulette'),
    Repair = require_action('RepairAction'),
    SolidReason = require_action('SolidReason'),
    Sprint = require_action('Sprint'),
    WiseToTheWorld = require_action('WiseToTheWorld'),
}
