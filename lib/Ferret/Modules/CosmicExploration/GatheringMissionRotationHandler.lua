--------------------------------------------------------------------------------
--   DESCRIPTION: Handler for doing gathering mission rotations
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class GatheringMissionRotationHandler : Object
local GatheringMissionRotationHandler = Object:extend()

function GatheringMissionRotationHandler:new()
    self.config = {
        [GatheringType.ItemCount] = {
            use_bountiful = function(mission, index)
                return true
            end,
        },
        [GatheringType.Chain] = {
            use_integrity_action = function(mission, index)
                return Gathering:get_integrity() <= 2
            end,
        },
        [GatheringType.Boon] = {
            use_boon_10 = function(mission, index)
                local chance = Addons.Gathering:get_boon_chance(index)
                return (chance >= 90 and chance < 100) or chance < 70
            end,
            use_boon_30 = function(mission, index)
                return Addons.Gathering:get_boon_chance(index) < 100
            end,
        },
        [GatheringType.ChainBoon] = {
            use_integrity_action = function(mission, index)
                return false
            end,
            use_boon_10 = function(mission, index)
                local chance = Addons.Gathering:get_boon_chance(index)
                return (chance >= 90 and chance < 100) or chance < 70
            end,
            use_boon_30 = function(mission, index)
                return Addons.Gathering:get_boon_chance(index) < 100
            end,
        },
        [GatheringType.Collectability] = {
            high_gp_threshold = 900,
            high_gp = function(mission, index)
                Logger:debug('High gp')
                Gathering:execute(GatheringActionType.PrimingTouch)
                Gathering:execute(GatheringActionType.Scrutiny)
                Gathering:execute(GatheringActionType.Meticulous)

                Gathering:execute(GatheringActionType.PrimingTouch)
                Gathering:execute(GatheringActionType.Scrutiny)
                Gathering:execute(GatheringActionType.Meticulous)

                local collectability = Addons.GatheringMasterpiece:get_collectablility()

                if collectability >= 1000 then
                    self:gather_all_collectables()
                    return
                end

                if
                    collectability >= 850
                    or Character:has_status(Status.CollectorsHighStandard)
                    or Character:has_status(Status.CollectorsStandard)
                then
                    Gathering:execute(GatheringActionType.Meticulous)
                    self:gather_all_collectables()
                    return
                end

                Gathering:execute(GatheringActionType.Scour)
                if Addons.GatheringMasterpiece:get_collectablility() < 1000 then
                    Gathering:execute(GatheringActionType.Meticulous)
                end

                self:gather_all_collectables()
            end,
            low_gp = function(mission, index)
                -- Do things here...
                self:gather_all_collectables()
            end,
        },
        [GatheringType.CollectabilityItemCount] = {},
        [GatheringType.TimeTrial] = {},
        [GatheringType.LargeFish] = {},
        [GatheringType.FishCountSize] = {},
        [GatheringType.FishSize] = {},
        [GatheringType.Variety] = {},
    }
end

function GatheringMissionRotationHandler:handle(mission, index)
    if mission:is_collectable_mission() then
        Gathering:start_collect(index)
        Addons.GatheringMasterpiece:wait_until_ready()
        Wait:seconds(0.5)
    end

    if mission.gathering_type == GatheringType.ItemCount then
        self:item_count(mission, index)
    elseif mission.gathering_type == GatheringType.Chain then
        self:chain(mission, index)
    elseif mission.gathering_type == GatheringType.Boon then
        self:boon(mission, index)
    elseif mission.gathering_type == GatheringType.ChainBoon then
        self:chain_boon(mission, index)
    elseif mission.gathering_type == GatheringType.Collectability then
        self:collectability(mission, index)
    elseif mission.gathering_type == GatheringType.CollectabilityItemCount then
        self:collectability_item_count(mission, index)
    elseif mission.gathering_type == GatheringType.TimeTrial then
        self:time_trial(mission, index)
    elseif mission.gathering_type == GatheringType.LargeFish then
        self:large_fish(mission, index)
    elseif mission.gathering_type == GatheringType.FishCountSize then
        self:fish_count_size(mission, index)
    elseif mission.gathering_type == GatheringType.FishSize then
        self:fish_size(mission, index)
    elseif mission.gathering_type == GatheringType.Variety then
        self:variety(mission, index)
    else
        Logger:debug('Unhandled gathering type: ' .. mission.gathering_type)
    end
end

function GatheringMissionRotationHandler:item_count(mission, index)
    if self.config[GatheringType.Chain].use_bountiful(mission, index) then
        Gathering:execute(GatheringActionType.Bountiful)
    end

    Gathering:gather(index)
end

function GatheringMissionRotationHandler:chain(mission, index)
    if self.config[GatheringType.Boon].use_integrity_action(mission, index) then
        Gathering:execute(GatheringActionType.Integrity)
        if Gathering:has_eureka_moment() then
            Gathering:execute(GatheringActionType.WiseToTheWorld)
        end
    end

    Gathering:gather(index)
end

function GatheringMissionRotationHandler:boon(mission, index)
    if self.config[GatheringType.Boon].use_boon_10(mission, index) then
        Gathering:execute(GatheringActionType.Boon_10)
    end

    if self.config[GatheringType.Boon].use_boon_30(mission, index) then
        Gathering:execute(GatheringActionType.Boon_30)
    end

    Gathering:gather(index)
end

function GatheringMissionRotationHandler:chain_boon(mission, index)
    if self.config[GatheringType.ChainBoon].use_bountiful(mission, index) then
        Gathering:execute(GatheringActionType.Bountiful)
    end

    if self.config[GatheringType.ChainBoon].use_boon_10(mission, index) then
        Gathering:execute(GatheringActionType.Boon_10)
    end

    if self.config[GatheringType.ChainBoon].use_boon_30(mission, index) then
        Gathering:execute(GatheringActionType.Boon_30)
    end

    Gathering:gather(index)
end

function GatheringMissionRotationHandler:collectability(mission, index)
    if self.config[GatheringType.Collectability].high_gp_threshold <= Gathering:get_gp() then
        self.config[GatheringType.Collectability].high_gp(mission, index)
    else
        self.config[GatheringType.Collectability].low_gp(mission, index)
    end
end

function GatheringMissionRotationHandler:collectability_item_count(mission, index)
    if self.config[GatheringType.CollectabilityItemCount].high_gp_threshold <= Gathering:get_gp() then
        self.config[GatheringType.CollectabilityItemCount].high_gp(mission, index)
    else
        self.config[GatheringType.CollectabilityItemCount].low_gp(mission, index)
    end

    Gathering:wait_to_stop()
    self:reduce()
end

function GatheringMissionRotationHandler:time_trial(mission, index)
    error('Fishing not supported yet')
end

function GatheringMissionRotationHandler:large_fish(mission, index)
    error('Fishing not supported yet')
end

function GatheringMissionRotationHandler:fish_count_size(mission, index)
    error('Fishing not supported yet')
end

function GatheringMissionRotationHandler:fish_size(mission, index)
    error('Fishing not supported yet')
end

function GatheringMissionRotationHandler:variety(mission, index)
    error('Fishing not supported yet')
end

function GatheringMissionRotationHandler:gather_all_collectables()
    repeat
        if Addons.GatheringMasterpiece:get_integrity() <= 2 then
            Gathering:execute(GatheringActionType.Integrity)
            if Gathering:has_eureka_moment() then
                Gathering:execute(GatheringActionType.WiseToTheWorld)
            end
        end

        Gathering:execute(GatheringActionType.Collect)
    until not Gathering:is_gathering()
end

function GatheringMissionRotationHandler:reduce()
    PauseYesAlready()
    if not Addons.PurifyItemSelector:is_visible() and not Mount:is_mounted() then
        Actions.AetherialReduction:execute()
        Wait:seconds(0.5)
    end

    Addons.PurifyItemSelector:wait_until_ready()
    Wait:seconds(0.5)
    Addons.PurifyItemSelector:click_first()

    Addons.PurifyResult:wait_until_ready()
    Wait:seconds(0.5)
    Addons.PurifyResult:auto()

    Addons.PurifyAutoDialog:wait_until_ready()
    Addons.PurifyAutoDialog:wait_for_exit()
    Wait:seconds(0.5)
    Addons.PurifyAutoDialog:exit()
    Wait:seconds(0.5)
    Addons.PurifyItemSelector:exit()

    RestoreYesAlready()
end

return GatheringMissionRotationHandler()
