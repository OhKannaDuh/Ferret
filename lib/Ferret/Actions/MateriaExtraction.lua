--------------------------------------------------------------------------------
--   DESCRIPTION: Action for opening the Materia Extraction interface
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class MateriaExtraction : Action
local MateriaExtraction = Action:extend()
function MateriaExtraction:new()
    MateriaExtraction.super.new(self, i18n('actions.materia_extraction'))
end

return MateriaExtraction()
