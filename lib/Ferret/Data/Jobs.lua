--------------------------------------------------------------------------------
--   DESCRIPTION: Job names to ids
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@alias Job integer
Jobs = {
    Unknown = -1,
    Carpenter = 8,
    Blacksmith = 9,
    Armorer = 10,
    Goldsmith = 11,
    Leatherworker = 12,
    Weaver = 13,
    Alchemist = 14,
    Culinarian = 15,
    Miner = 16,
    Botanist = 17,
    Fisher = 18,
}

Jobs.gearset_name_map = {
    [Jobs.Unknown] = i18n('jobs.unknown'),
    [Jobs.Carpenter] = i18n('jobs.carpenter'),
    [Jobs.Blacksmith] = i18n('jobs.blacksmith'),
    [Jobs.Armorer] = i18n('jobs.armorer'),
    [Jobs.Goldsmith] = i18n('jobs.goldsmith'),
    [Jobs.Leatherworker] = i18n('jobs.leatherworker'),
    [Jobs.Weaver] = i18n('jobs.weaver'),
    [Jobs.Alchemist] = i18n('jobs.alchemist'),
    [Jobs.Culinarian] = i18n('jobs.culinarian'),
    [Jobs.Miner] = i18n('jobs.miner'),
    [Jobs.Botanist] = i18n('jobs.botanist'),
    [Jobs.Fisher] = i18n('jobs.fisher'),
}

function Jobs.to_string(job)
    return Jobs.gearset_name_map[job]
end

function Jobs.change_to(job)
    yield('/gearset change ' .. Jobs.to_string(job))
end
