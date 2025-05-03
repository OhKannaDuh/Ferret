--------------------------------------------------------------------------------
--   DESCRIPTION: Extension manager
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class ExtensionManager : Object, Translation
local ExtensionManager = Object:extend()
ExtensionManager:implement(Translation)

function ExtensionManager:new()
    self.translation_path = 'extension.manager'

    self.extensions = {}
end

function ExtensionManager:load(name)
    local extension = require('Ferret/Extensions/' .. name)
    return self:register(extension)
end

---@param extension Extension
function ExtensionManager:register(extension)
    self:log_debug('add', { extension = extension })

    extension:init(self)

    self.extensions[extension.key] = extension

    return extension
end

return ExtensionManager()
