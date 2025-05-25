--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for the Materia Extraction screen
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Materialize : Addon
local Materialize = Addon:extend()

function Materialize:new()
    Materialize.super.new(self, 'Materialize')
end

function Materialize:open()
    Actions.MateriaExtraction:execute()
end

function Materialize:close()
    self:callback(true, -1)
end

function Materialize:click_first_slot()
    self:callback(true, 2)
end

return Materialize()
