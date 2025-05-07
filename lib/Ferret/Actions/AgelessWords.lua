--------------------------------------------------------------------------------
--   DESCRIPTION: Action for AgelessWords
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class AgelessWords : Action
local AgelessWords = Action:extend()
function AgelessWords:new()
    AgelessWords.super.new(self, i18n('actions.ageless_words'))
end

return AgelessWords()
