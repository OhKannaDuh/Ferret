--------------------------------------------------------------------------------
--   DESCRIPTION:
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

GatheringActionType = {
    Bountiful = 1,
    Integrity = 2,
    WiseToTheWorld = 3,
    Boon_10 = 4,
    Boon_30 = 5,
    Collect = 6,
    Scour = 7,
    Brazen = 8,
    Meticulous = 9,
    Scrutiny = 10,
    CollectorsFocus = 11,
    PrimingTouch = 12,
}

GatheringActionCosts = {
    [GatheringActionType.Bountiful] = 100,
    [GatheringActionType.Integrity] = 300,
    [GatheringActionType.WiseToTheWorld] = 0,
    [GatheringActionType.Boon_10] = 50,
    [GatheringActionType.Boon_30] = 100,
    [GatheringActionType.Collect] = 0,
    [GatheringActionType.Scour] = 0,
    [GatheringActionType.Brazen] = 0,
    [GatheringActionType.Meticulous] = 0,
    [GatheringActionType.Scrutiny] = 200,
    [GatheringActionType.CollectorsFocus] = 100,
    [GatheringActionType.PrimingTouch] = 100,
}

GatheringActions = {
    [Jobs.Miner] = {
        [GatheringActionType.Bountiful] = 272,
        [GatheringActionType.Integrity] = 232,
        [GatheringActionType.WiseToTheWorld] = 26521,
        [GatheringActionType.Boon_10] = 21177,
        [GatheringActionType.Boon_30] = 25589,
        [GatheringActionType.Collect] = 240,
        [GatheringActionType.Scour] = 22182,
        [GatheringActionType.Brazen] = 22183,
        [GatheringActionType.Meticulous] = 22184,
        [GatheringActionType.Scrutiny] = 22185,
        [GatheringActionType.CollectorsFocus] = 21205,
        [GatheringActionType.PrimingTouch] = 34871,
    },
    [Jobs.Botanist] = {
        [GatheringActionType.Bountiful] = 273,
        [GatheringActionType.Integrity] = 215,
        [GatheringActionType.WiseToTheWorld] = 26522,
        [GatheringActionType.Boon_10] = 21178,
        [GatheringActionType.Boon_30] = 25590,
        [GatheringActionType.Collect] = 815,
        [GatheringActionType.Scour] = 22186,
        [GatheringActionType.Brazen] = 22187,
        [GatheringActionType.Meticulous] = 22188,
        [GatheringActionType.Scrutiny] = 22189,
        [GatheringActionType.CollectorsFocus] = 21206,
        [GatheringActionType.PrimingTouch] = 34872,
    },
}
