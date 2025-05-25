--------------------------------------------------------------------------------
--   DESCRIPTION: Cosmic Exploration module
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Core : Module, Translation
local Core = Module:extend()
Core:implement(Translation)

function Core:new()
    Core.super.new(self, 'Core', Version(0, 1, 1))
    self.translation_path = 'modules.core'
end

function Core:get_addon_mixins()
    return {
        'GracefulClose',
        'GracefulOpen'
    }
end

function Core:get_addons()
    return {
        ['Gathering'] = 'GatheringAddon',
        'GatheringMasterpiece',
        'MaterializeDialog',
        'Materialize',
        'PurifyAutoDialog',
        'PurifyItemSelector',
        'PurifyResult',
        'RecipeNote',
        'SelectIconString',
        'SelectString',
        'SelectYesno',
        'ShopExchangeCurrency',
        'SpearFishing',
        'Synthesis',
        'Talk',
        'ToDoList',
    }
end

function Core:get_models()
    return {}
end

function Core:load_static()
end



function Core:init()
    Module.init(self)

    self:log_info('Initialising Core module ' .. self.version:to_string())

end

return Core():init()
