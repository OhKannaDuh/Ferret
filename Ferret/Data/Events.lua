--------------------------------------------------------------------------------
--   DESCRIPTION: Events for ferret callbacks
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@alias Event integer
Events = {
    PRE_LOOP = 1,
    POST_LOOP = 2,
    PRE_CRAFT = 3,
}

--- Converts an request ID to its string representation.
---@param request Event
---@return string
function Events.to_string(request)
    for name, id in pairs(Events) do
        if id == request then
            return name
        end
    end
    return 'UNKNOWN_EVENT'
end
