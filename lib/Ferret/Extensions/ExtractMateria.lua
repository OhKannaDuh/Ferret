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
                repeat
                    Addons.Materialize:click_first_slot()
                    Wait:seconds(0.5)
                until Addons.MaterializeDialog:is_visible()

                repeat
                    Addons.MaterializeDialog:yes()
                    Wait:seconds(0.5)
                until not Addons.MaterializeDialog:is_visible()
            end

            repeat
                Wait:seconds(0.1)
            until not GetCharacterCondition(Conditions.Occupied39)
        end

        Addons.Materialize:close()
        self:log_debug('done')
    end)
end

return ExtractMateria()
