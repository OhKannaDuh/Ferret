--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for Quest list (Not Journal)
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class ToDoList : Addon
local ToDoList = Addon:extend()
function ToDoList:new()
    ToDoList.super.new(self, '_ToDoList')
end

function ToDoList:get_count()
    return GetNodeListCount(self.key)
end

---@return MissionResult
function ToDoList:get_stellar_mission_scores()
    local silver_patern = Translatable('Current Score: ([%d,]+)%. Silver Star Requirement: ([%d,]+)')
        :with_de('Aktuell: ([%d%.]+) / Silber: ([%d%.]+)')
        :with_fr('Évaluation : ([%d%s]+) / Rang argent : ([%d%s]+)')
        :with_jp('現在の評価値: ([%d,]+) / シルバーグレード条件: ([%d,]+)')

    local gold_pattern = Translatable('Current Score: ([%d,]+)%. Gold Star Requirement: ([%d,]+)')
        :with_de('Aktuell: ([%d%.]+) / Gold: ([%d%.]+)')
        :with_fr('Évaluation : ([%d%s]+) / Rang or : ([%d%s]+)')
        :with_jp('現在の評価値: ([%d,]+) / ゴールドグレード条件: ([%d,]+)')

    local has_bronze = self:has_stellar_mission_bronze()
    if not has_bronze then
        return MissionScore(MissionResult.Fail, 0, 0)
    end

    for side = 1, 2 do
        for i = 1, self:get_count() do
            local node_text = self:get_node_text(i, side)
            local current, silver = string.match(node_text, silver_patern:get())

            if current and silver then
                current = String:parse_number(current)
                silver = String:parse_number(silver)

                if has_bronze then
                    return MissionScore(MissionResult.Bronze, current, silver)
                else
                    return MissionScore(MissionResult.Fail, current, silver)
                end
            end

            local current, gold = string.match(node_text, gold_pattern:get())

            if current and gold then
                current = String:parse_number(current)
                gold = String:parse_number(gold)

                if current < gold then
                    return MissionScore(MissionResult.Silver, current, gold)
                end

                return MissionScore(MissionResult.Gold, current, gold)
            end
        end
    end

    return MissionScore(MissionResult.Fail, 0, 0)
end

function ToDoList:has_stellar_mission_bronze()
    local completions = self:get_stellar_mission_craft_completions()
    local has_bronze = true
    for _, completion in ipairs(completions) do
        if completion.crafted < completion.required then
            has_bronze = false
            break
        end
    end

    return has_bronze
end

function ToDoList:get_stellar_mission_name()
    for i = 1, self:get_count() do
        local node_text = self:get_node_text(i, 13)
        if String:starts_with(node_text, ' ') then
            return node_text:gsub(' ', '')
        end

        if String:starts_with(node_text, 'A-') then
            return node_text
        end
    end

    return nil
end

function ToDoList:get_stellar_mission_craft_completions()
    local matches = {}
    local pattern = Translatable('.-crafted: (%d+)/(%d+)')
        :with_de('.-hergestellt: (%d+)/(%d+)')
        :with_fr('.-fabriqué : (%d+)/(%d+)')
        :with_jp('.-作成済み: (%d+)/(%d+)')

    for i = 1, self:get_count() do
        local node_text = self:get_node_text(i, 3)
        local crafted, required = string.match(node_text, pattern:get())
        if crafted and required then
            table.insert(matches, {
                crafted = String:parse_number(crafted),
                required = String:parse_number(required),
            })
        end
    end

    return matches
end

function ToDoList:get_time_remaining()
    -- @todo check this works dynamically and across localisations
    local timer = self:get_node_text(6, 2)
    local minutes, seconds = string.match(timer, '(%d+):(%d+)')
    if minutes and seconds then
        return tonumber(minutes) * 60 + tonumber(seconds)
    end

    return math.maxinteger
end

return ToDoList()
