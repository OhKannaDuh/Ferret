--------------------------------------------------------------------------------
--   DESCRIPTION: Plugin that extracts materia before a loop
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class ExtractMateria : Plugin
ExtractMateria = Plugin:extend()
function ExtractMateria:new()
    ExtractMateria.super.new(self, 'Extract Materia', 'extract_materia')
end

function ExtractMateria:init()
    HookManager:subscribe(Hooks.PRE_LOOP, function(context)
        Logger:debug_t('plugins.extract_materia.check')

        if not CanExtractMateria() then
            Logger:debug_t('plugins.extract_materia.not_needed')
            return
        end

        if not Addons.Materialize:is_visible() then
            Addons.Materialize:open()
            Addons.Materialize:wait_until_ready()
        end

        Logger:debug_t('plugins.extract_materia.extracting')

        while CanExtractMateria(100) do
            if Addons.Materialize:is_visible() then
                Ferret:repeat_until(function()
                    Addons.Materialize:click_first_slot()
                end, function()
                    return Addons.MaterializeDialog:is_visible()
                end)

                Ferret:repeat_until(function()
                    Addons.MaterializeDialog:yes()
                end, function()
                    return not Addons.MaterializeDialog:is_visible()
                end)
            end

            Ferret:wait_until(function()
                return not GetCharacterCondition(Conditions.Occupied39)
            end)
        end

        Addons.Materialize:close()
        Logger:debug_t('plugins.extract_materia.done')
    end)
end

Ferret:add_plugin(ExtractMateria())
