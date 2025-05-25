--------------------------------------------------------------------------------
--   DESCRIPTION: Extension that repairs your gear before a loop
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Repair : Extension
---@field threshold integer
local Repair = Extension:extend()
function Repair:new()
    Repair.super.new(self, 'Repair', 'repair')
    self.threshold = 50
end

function Repair:init()
    EventManager:subscribe(Events.PRE_LOOP, function(context)
        self:log_debug('check')
        if not NeedsRepair(self.threshold) then
            self:log_debug('not_needed')
            return
        end

        PauseYesAlready()

        self:log_debug('repairing')
        while not IsAddonVisible('Repair') do
            Actions.Repair:execute()
            Wait:seconds(0.5)
        end

        yield('/callback Repair true 0')
        Wait:seconds(0.1)

        if Addons.SelectYesno:is_visible() then
            Addons.SelectYesno:yes()
            Wait:seconds(0.1)
        end

        Wait:seconds_until(function()
            return not GetCharacterCondition(Conditions.Occupied39)
        end)

        Wait:seconds(1)
        yield('/callback Repair true -1')
        self:log_debug('done')

        RestoreYesAlready()
    end)
end

return Repair()
