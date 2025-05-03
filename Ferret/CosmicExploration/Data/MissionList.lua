--------------------------------------------------------------------------------
--   DESCRIPTION: CosmicExploration Mission List
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class MissionList : Object, Translation
---@field missions Mission[]
MissionList = Object:extend()
MissionList:implement(Translation)

MissionList.debug = {
    finding_mission_by_name = false,
}

function MissionList:new()
    self.translation_path = 'modules.cosmic_exploration.mission_list'
    self.missions = {}
end

---@param mission Mission
function MissionList:add(mission)
    table.insert(self.missions, mission)
end

---@param callback  fun(mission: Mission): boolean
function MissionList:filter(callback)
    local filtered = MissionList()
    for _, mission in ipairs(self.missions) do
        if callback(mission) then
            table.insert(filtered.missions, mission)
        end
    end

    return filtered
end

---@param job Job
function MissionList:filter_by_job(job)
    return self:filter(function(mission)
        return mission.job == job
    end)
end

---@param class string
function MissionList:filter_by_class(class)
    Logger:debug('Filtering missions by class: ' .. class)
    return self:filter(function(mission)
        return mission.class == class
    end)
end

---@param names string[]
function MissionList:filter_by_names(names)
    Logger:debug('Filtering missions by names: ' .. table.concat(names, ', '))
    local filtered = MissionList()

    for _, wanted_name in ipairs(names) do
        wanted_name = string.upper(wanted_name)

        for _, mission in ipairs(self.missions) do
            if string.upper(mission.name:get()) == wanted_name then
                table.insert(filtered.missions, mission)
                break
            end
        end
    end

    return filtered
end

---@param ids integer[]
function MissionList:filter_by_ids(ids)
    Logger:debug('Filtering missions by ids: ' .. table.concat(ids, ', '))
    local filtered = MissionList()

    for _, id in ipairs(ids) do
        local mission = self:find_by_id(id)
        if mission then
            filtered:add(mission)
        end
    end

    return filtered
end

---@param name string
function MissionList:find_by_name(name)
    self:log_debug('find_by_name', { name = name }, MissionList.debug.finding_mission_by_name)

    name = string.upper(name)
    for _, mission in pairs(self.missions) do
        local start_index = string.find(string.upper(mission.name:get()), name, 0, true)

        if start_index ~= nil and start_index <= 4 then
            return mission
        end
    end

    return nil
end

---@param id integer
---@return Mission|nil
function MissionList:find_by_id(id)
    Logger:debug('Finding mission by id: ' .. id)
    for _, mission in pairs(self.missions) do
        if mission.id == id then
            return mission
        end
    end

    return nil
end

---@return Mission|nil
function MissionList:first()
    for _, mission in pairs(self.missions) do
        return mission
    end

    return nil
end

---@return Mission|nil
function MissionList:random()
    local keys = {}

    for _, mission in pairs(self.missions) do
        table.insert(keys, _)
    end
    if #keys <= 0 then
        return nil
    end

    local key = keys[math.random(1, #keys)]
    return self.missions[key]
end

---@param id integer
---@return boolean
function MissionList:has_id(id)
    for _, mission in pairs(self.missions) do
        if mission.id == id then
            return true
        end
    end

    return false
end

---@param other MissionList
---@return MissionList
function MissionList:get_overlap(other)
    local overlap = MissionList()

    for _, mission in pairs(self.missions) do
        if other:has_id(mission.id) then
            table.insert(overlap.missions, mission)
        end
    end

    return overlap
end

---@return boolean
function MissionList:is_empty()
    return Table:is_empty(self.missions)
end

---@return string[]
function MissionList:get_classes()
    local classes = {}

    for _, mission in ipairs(self.missions) do
        if not Table:contains(classes, mission.class) then
            table.insert(classes, mission.class)
        end
    end

    return classes
end

function MissionList:count()
    return Table:count(self.missions)
end

---@return string
function MissionList:to_string()
    local missions = {}
    for _, mission in ipairs(self.missions) do
        table.insert(missions, mission.name:get())
    end

    return 'Mission List: ' .. table.concat(missions, ', ')
end

---@return string
function MissionList:to_id_string()
    local missions = {}
    for _, mission in ipairs(self.missions) do
        table.insert(missions, mission.id)
    end

    return 'Mission List: ' .. table.concat(missions, ', ')
end
