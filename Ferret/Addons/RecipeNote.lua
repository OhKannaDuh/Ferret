--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for RecipeNote (Recipe list)
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class RecipeNote : Addon
local RecipeNote = Addon:extend()
RecipeNote:implement(AddonMixins.GracefulClose, AddonMixins.GracefulOpen)

function RecipeNote:new()
    RecipeNote.super.new(self, 'RecipeNote')
end

function RecipeNote:open()
    Actions.CraftingLog:execute()
end

return RecipeNote()
