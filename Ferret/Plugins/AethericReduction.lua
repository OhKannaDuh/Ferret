--------------------------------------------------------------------------------
--   DESCRIPTION: Plugin that Aetheric Reduces things
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class AethericReduction : Plugin, Translation
---@field reduce_at integer
AethericReduction = Plugin:extend()
AethericReduction:implement(Translation)

function AethericReduction:new()
    AethericReduction.super.new(self, 'AethericReduction', 'aetheric_reduction')
    self.reduce_at = 100

    self.translation_path = 'plugins.aetheric_reduction'
end

function AethericReduction:init()
    HookManager:subscribe(Hooks.POST_LOOP, function(context)
        self:log_info('check')
        if GetInventoryFreeSlotCount() > self.reduce_at then
            self:log_info('not_needed')
            return
        end

        PauseYesAlready()
        if not Addons.PurifyItemSelector:is_visible() and not Mount:is_mounted() then
            Actions.AetherialReduction:execute()
            Ferret:wait(0.5)
        end

        Addons.PurifyItemSelector:wait_until_ready()
        Ferret:wait(0.5)
        Addons.PurifyItemSelector:click_first()

        Addons.PurifyResult:wait_until_ready()
        Ferret:wait(0.5)
        Addons.PurifyResult:auto()

        Addons.PurifyAutoDialog:wait_until_ready()
        Addons.PurifyAutoDialog:wait_for_exit()
        Ferret:wait(0.5)
        Addons.PurifyAutoDialog:exit()
        Ferret:wait(0.5)
        Addons.PurifyItemSelector:exit()

        RestoreYesAlready()
    end)
end

Ferret:add_plugin(AethericReduction())
