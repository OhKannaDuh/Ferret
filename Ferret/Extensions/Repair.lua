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

        self:log_debug('repairing')
        while not IsAddonVisible('Repair') do
            Actions.Repair:execute()
            Ferret:wait(0.5)
        end

        yield('/callback Repair true 0')
        Ferret:wait(0.1)

        if Addons.SelectYesno:is_visible() then
            Addons.SelectYesno:yes()
            Ferret:wait(0.1)
        end

        Ferret:wait_until(function()
            return not GetCharacterCondition(Conditions.Occupied39)
        end)

        Ferret:wait(1)
        yield('/callback Repair true -1')
        self:log_debug('done')
    end)
end

return Repair()
