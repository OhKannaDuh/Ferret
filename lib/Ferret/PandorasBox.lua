--------------------------------------------------------------------------------
--   DESCRIPTION: Pandora's Box config
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

PandorasBoxFeature = {
    AutoInteract = 'Auto-interact with Gathering Nodes',
    AutoGather = 'Pandora Quick Gather',
}

---@class PandorasBox : Object
local PandorasBox = Object:extend()
function PandorasBox:new()
    self.features_to_track = {
        PandorasBoxFeature.AutoInteract,
        PandorasBoxFeature.AutoGather,
    }

    self.feature_state = {}

    for _, feature in ipairs(self.features_to_track) do
        self.feature_state[feature] = PandoraGetFeatureEnabled(feature)
    end
end

function PandorasBox:pause(feature)
    PandoraSetFeatureState(feature, false)
end

function PandorasBox:restore()
    for feature, state in pairs(self.feature_state) do
        PandoraSetFeatureState(feature, state)
    end
end

return PandorasBox()
