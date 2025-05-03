--------------------------------------------------------------------------------
--   DESCRIPTION: Extension that extracts materia before a loop
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class ExtractMateria : Extension
local ExtractMateria = Extension:extend()
function ExtractMateria:new()
    ExtractMateria.super.new(self, 'Extract Materia', 'extract_materia')
end

function ExtractMateria:init()
    EventManager:subscribe(Events.PRE_LOOP, function(context)
        self:log_debug('check')

        if not CanExtractMateria() then
            self:log_debug('not_needed')
            return
        end

        if not Addons.Materialize:is_visible() then
            Addons.Materialize:open()
            Addons.Materialize:wait_until_ready()
        end

        self:log_debug('extracting')
        RequestManager:request(Requests.STOP_CRAFT)

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
        self:log_debug('done')
    end)
end

return ExtractMateria()
