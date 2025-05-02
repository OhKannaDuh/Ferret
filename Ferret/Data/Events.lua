--------------------------------------------------------------------------------
--   DESCRIPTION: Events for ferret callbacks
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@alias Event integer
Events = {
    STOP_CRAFT = 1,
    PREPARE_TO_CRAFT = 2,
}

--- Converts an event ID to its string representation.
---@param event Event
---@return string
function Events.to_string(event)
    for name, id in pairs(Events) do
        if id == event then
            return name
        end
    end
    return 'UNKNOWN_EVENT'
end
