--------------------------------------------------------------------------------
--   DESCRIPTION: Base module
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Module : Object
Module = Object:extend()
Module:implement(Translation)

function Module:new(key, version)
    self.key = key
    self.version = version

    self:load_addons()
    self:load_models()
    self:load_static()
end

function Module:require(path)
    return module_require(self.key, path)
end

function Module:get_addons()
    return {}
end

function Module:get_models()
    return {}
end

function Module:init()
    return self
end

function Module:load_addons()
    for _, addon in pairs(self:get_addons()) do
        Addons[addon] = self:require('Addons/' .. addon)
    end
end

function Module:load_models()
    for _, model in pairs(self:get_models()) do
        self:require('Models/' .. model)
    end
end

function Module:load_static() end
