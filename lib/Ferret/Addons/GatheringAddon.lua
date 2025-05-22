--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for the Gathering window
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class GatheringAddon : Addon
local GatheringAddon = Addon:extend()

function GatheringAddon:new()
    GatheringAddon.super.new(self, 'Gathering')
end

function GatheringAddon:get_integrity()
    return self:get_node_number(33)
end

function GatheringAddon:get_items()
    local items = {}

    local index = 0
    for i = 25, 18, -1 do
        local text = self:get_node_text(i, 14)
        text = text:gsub('[^%w%s%p]', '')
        if text ~= '' and text ~= 14 then
            Logger:debug(text)
            table.insert(items, {
                item = text,
                index = index,
            })
        end

        index = index + 1
    end

    return items
end

function GatheringAddon:gather(index)
    self:callback(true, index)
end

return GatheringAddon()
