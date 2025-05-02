--------------------------------------------------------------------------------
--   DESCRIPTION: Addons list
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

require('Ferret/Addons/Addon')

local function require_addon_mixin(name)
    return require('Ferret/Addons/Mixins/' .. name)
end

local function require_addon(name)
    return require('Ferret/Addons/' .. name)
end

AddonMixins = {
    GracefulClose = require_addon_mixin('GracefulClose'),
    GracefulOpen = require_addon_mixin('GracefulOpen'),
}

Addons = {
    Gathering = require_addon('GatheringAddon'),
    GatheringMasterpiece = require_addon('GatheringMasterpiece'),
    Materialize = require_addon('Materialize'),
    MaterializeDialog = require_addon('MaterializeDialog'),
    PurifyAutoDialog = require_addon('PurifyAutoDialog'),
    PurifyItemSelector = require_addon('PurifyItemSelector'),
    PurifyResult = require_addon('PurifyResult'),
    RecipeNote = require_addon('RecipeNote'),
    SelectIconString = require_addon('SelectIconString'),
    SelectString = require_addon('SelectString'),
    SelectYesno = require_addon('SelectYesno'),
    SpearFishing = require_addon('SpearFishing'),
    Synthesis = require_addon('Synthesis'),
    Talk = require_addon('Talk'),
    ToDoList = require_addon('ToDoList'),
}
