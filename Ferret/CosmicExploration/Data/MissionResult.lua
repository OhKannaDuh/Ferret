--------------------------------------------------------------------------------
--   DESCRIPTION: Mission result, fail, bronze, silver, gold etc.
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@alias MissionResult integer
MissionResult = {
    Fail = 1,
    Bronze = 2,
    Silver = 3,
    Gold = 4,
}

function MissionResult.to_string(value)
    local map = {
        [MissionResult.Fail] = 'Fail',
        [MissionResult.Bronze] = 'Bronze',
        [MissionResult.Silver] = 'Silver',
        [MissionResult.Gold] = 'Gold',
    }

    return map[value] or ('Unknown - ' .. tostring(value))
end
