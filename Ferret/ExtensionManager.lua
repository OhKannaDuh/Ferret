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

function ExtensionManager:load(...)
    local extensions = {}
    for _, name in ipairs({ ... }) do
        local extension = require('Ferret/Extensions/' .. name)
        table.insert(extensions, self:register(extension))
    end

    return table.unpack(extensions)
end

---@param extension Extension
function ExtensionManager:register(extension)
    self:log_debug('add', { extension = extension })

    extension:init()

    self.extensions[extension.key] = extension

    return extension
end

return ExtensionManager()
