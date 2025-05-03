--------------------------------------------------------------------------------
--   DESCRIPTION: Requests for ferret callbacks
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@alias Request integer
Requests = {
    STOP_CRAFT = 1, -- Makes the player quit synthesis, close the recipe note and stand up, etc.
    PREPARE_TO_CRAFT = 2, -- Make sure the recipe notebook is open and ready to use
    START_CRAFT = 3, -- Start the craft, i.e. clicking synthesize or calling artisan
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
