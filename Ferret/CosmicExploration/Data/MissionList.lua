--------------------------------------------------------------------------------
--   DESCRIPTION: CosmicExploration Mission List
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

MissionList = Object:extend()
function MissionList:new()
    self.missions = {}
end

function MissionList:add(mission)
    table.insert(self.missions, mission)
end

function MissionList:filter(callback)
    local filtered = MissionList()
    for _, mission in ipairs(self.missions) do
        if callback(mission) then
            table.insert(filtered.missions, mission)
        end
    end

    return filtered
end

function MissionList:filter_by_job(job)
    return self:filter(function(mission)
        return mission.job == job
    end)
end

function MissionList:filter_by_class(class)
    return self:filter(function(mission)
        return mission.class == class
    end)
end

 function MissionList:filter_by_names(names)
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

function MissionList:filter_by_ids(ids)
    return self:filter(function(mission)
        return Ferret:table_contains(ids, mission.id)
    end)
end

function MissionList:find_by_name(name)
    name = string.upper(name)
    for _, mission in pairs(self.missions) do
        local start_index = string.find(string.upper(mission.name:get()), name, 0, true)

        if start_index ~= nil and start_index <= 4 then
            return mission
        end
    end

    return nil
end

function MissionList:first()
    for _, mission in pairs(self.missions) do
        return mission
    end

    return nil
end

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

function MissionList:has_id(id)
    for _, mission in pairs(self.missions) do
        if mission.id == id then
            return true
        end
    end

    return false
end

function MissionList:get_overlap(other)
    local overlap = MissionList()

    for _, mission in pairs(self.missions) do
        if other:has_id(mission.id) then
            table.insert(overlap.missions, mission)
        end
    end

    return overlap
end
