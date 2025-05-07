--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for the Materia Extraction Yes/No popup
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class MaterializeDialog : Addon
local MaterializeDialog = Addon:extend()

function MaterializeDialog:new()
    MaterializeDialog.super.new(self, 'MaterializeDialog')
end

function MaterializeDialog:yes()
    self:callback(true, 0)
end

function MaterializeDialog:no()
    self:callback(true, 1)
end

return MaterializeDialog()
