--------------------------------------------------------------------------------
--   DESCRIPTION: Action for MeticulouProspector
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class MeticulouProspector : Action
local MeticulouProspector = Action:extend()
function MeticulouProspector:new()
    MeticulouProspector.super.new(self, i18n('actions.meticulou_prospector'))
end

return MeticulouProspector()
