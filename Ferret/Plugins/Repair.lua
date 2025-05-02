--------------------------------------------------------------------------------
--   DESCRIPTION: Plugin that repairs your gear before a loop
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Repair : Plugin
---@field threshold integer
Repair = Plugin:extend()
function Repair:new()
    Repair.super.new(self, 'Repair', 'repair')
    self.threshold = 50
end

function Repair:init()
    HookManager:subscribe(Hooks.PRE_LOOP, function(context)
        Logger:debug_t('plugins.repair.check')
        if not NeedsRepair(self.threshold) then
            Logger:debug_t('plugins.repair.not_needed')
            return
        end

        Logger:debug_t('plugins.repair.repairing')
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
        Logger:debug_t('plugins.repair.done')
    end)
end

Ferret:add_plugin(Repair())
