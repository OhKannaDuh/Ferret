--------------------------------------------------------------------------------
--   DESCRIPTION: Requests for ferret callbacks
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@alias Request integer
Requests = {
    STOP_CRAFT = 1,
    PREPARE_TO_CRAFT = 2,
}

--- Converts an request ID to its string representation.
---@param request Request
---@return string
function Requests.to_string(request)
    for name, id in pairs(Requests) do
        if id == request then
            return name
        end
    end
    return 'UNKNOWN_EVENT'
end
