--------------------------------------------------------------------------------
--   DESCRIPTION: Action for mounting a random mount
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class MountRoulette : Action
local MountRoulette = Action:extend()
function MountRoulette:new()
    MountRoulette.super.new(self, i18n('actions.mount_roulette'))
end

return MountRoulette()
