--------------------------------------------------------------------------------
--   DESCRIPTION:
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class MissionScorer : Object
local MissionScorer = Object:extend()

function MissionScorer:score(mission)
    Addons.WKSMissionInfomation:graceful_open()

    local current = Addons.WKSMissionInfomation:get_current_score()
    if current == nil then
        Logger:debug('current score is nil')
    end

    local silver = Addons.WKSMissionInfomation:get_silver_requirement()
    if silver == nil then
        Logger:debug('silver requirement is nil')
    end

    local gold = Addons.WKSMissionInfomation:get_gold_requirement()
    if gold == nil then
        Logger:debug('gold requirement is nil')
    end

    local score = MissionScore(MissionResult.Fail, current, silver)

    local has_bronze = true
    for item_id, amount in ipairs(mission.bronze_requirement) do
        if not GetItemCount(tonumber(item_id)) >= amount then
            has_bronze = false
            break
        end
    end

    if has_bronze then
        score.tier = MissionResult.Bronze
    end

    if current >= silver then
        score.tier = MissionResult.Silver
        score.next = gold
    end

    if current >= gold then
        score.tier = MissionResult.Gold
    end

    return score
end

return MissionScorer()
