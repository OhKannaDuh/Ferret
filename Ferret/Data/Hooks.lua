--------------------------------------------------------------------------------
--   DESCRIPTION: Hooks for ferret callbacks
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@alias Hook integer
Hooks = {
    PRE_LOOP = 1,
    POST_LOOP = 2,
    PRE_CRAFT = 3,
}

--- Converts an request ID to its string representation.
---@param request Hook
---@return string
function Hooks.to_string(request)
    for name, id in pairs(Hooks) do
        if id == request then
            return name
        end
    end
    return 'UNKNOWN_HOOK'
end
