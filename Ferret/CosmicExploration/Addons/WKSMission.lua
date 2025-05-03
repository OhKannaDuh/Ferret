--------------------------------------------------------------------------------
--   DESCRIPTION: Cosmic exploration mission list
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class WKSMission : Addon, Translation
local WKSMission = Addon:extend()
WKSMission:implement(Translation)

function WKSMission:new()
    WKSMission.super.new(self, 'WKSMission')
    self.translation_path = 'modules.cosmic_exploration.wks_mission'
end

function WKSMission:start_mission(id)
    self:wait_until_ready()
    repeat
        if self:is_ready() then
            self:callback(true, 13, id)
        end
        Ferret:wait(0.1)
    until Addons.SelectYesno:is_visible()

    repeat
        if Addons.SelectYesno:is_ready() then
            Addons.SelectYesno:yes()
        end
        Ferret:wait(0.1)
    until not self:is_ready()
end

function WKSMission:open()
    self:log_debug('open')
    Addons.WKSHud:open_mission_menu()
end

-- Requires it's own implementation because it shares an opening method with WKSMissionInformation
function WKSMission:graceful_open()
    if self:is_ready() or Addons.WKSMissionInfomation:is_ready() then
        return false
    end

    repeat
        self:open()
        Wait:fps(5)
    until self:is_ready() or Addons.WKSMissionInfomation:is_ready()

    return self:is_ready()
end

function WKSMission:open_basic_missions()
    self:log_debug('open_basic')
    self:callback(true, 15, 0)
end

function WKSMission:open_critical_missions()
    self:log_debug('open_critical')
    self:callback(true, 15, 1)
end

function WKSMission:open_provisional_missions()
    self:log_debug('open_provisional')
    self:callback(true, 15, 2)
end

function WKSMission:get_available_missions()
    self:log_debug('getting_missions')

    local missions = MissionList()
    local names = {}

    for tab = 0, 2 do
        self:callback(true, 15, tab)
        self:wait_until_ready()

        for index = 2, 1000000 do
            local mission_name = self:get_node_text(89, index, 8) --
            if mission_name == 8 or mission_name == '' then
                break
            end

            mission_name = mission_name:gsub(' ', '')

            if not Table:contains(names, mission_name) then
                self:log_debug('mission_found', { mission = mission_name })
                table.insert(names, mission_name)
            end
        end
    end

    for _, mission_name in ipairs(names) do
        ---@diagnostic disable-next-line: undefined-field
        local mission = CosmicExploration.mission_list:find_by_name(mission_name)

        if mission ~= nil and mission:is_available() then
            missions:add(mission)
        end
    end

    return missions
end

function WKSMission:get_best_available_mission(blacklist, progress)
    -- Function to select the best mission based on urgency-weighted progress
    local function select_best_mission(progress, rewards)
        local urgencies = {}

        -- Step 1: Calculate urgency for each bar
        for i, bar in ipairs(progress) do
            local current, max = bar.current, bar.required
            if max and max > 0 then
                urgencies[i] = 1 - (current / max)
            else
                urgencies[i] = 0
            end
        end

        -- Step 2: Score each mission
        local best_score = -math.huge
        local best_index = -1

        for i, mission in pairs(rewards) do
            local score = 0
            for bar_index, progress in pairs(mission) do
                if urgencies[bar_index] then
                    score = score + urgencies[bar_index] * progress
                end
            end

            if score > best_score then
                best_score = score
                best_index = i
            end
        end

        return best_index
    end

    local rewards = {}
    local missions = self:get_available_missions()
    for index, mission in pairs(missions.missions) do
        if not blacklist:has_id(mission.id) then
            self:log_info('not_blacklisted', { mission = mission.name:get() })
            local r = {}
            for _, reward in pairs(mission.exp_reward) do
                r[reward.tier] = reward.amount
            end

            rewards[index] = r
        else
            self:log_info('blacklisted', { mission = mission.name:get() })
        end
    end

    return missions.missions[select_best_mission(progress, rewards)]
end

return WKSMission()
