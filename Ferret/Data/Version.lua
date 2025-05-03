--------------------------------------------------------------------------------
--   DESCRIPTION: Semantic versioning object
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Version : Object
---@field major integer
---@field minor integer
---@field patch integer
Version = Object:extend()
function Version:new(major, minor, patch)
    self.major = major
    self.minor = minor
    self.patch = patch
end

---@return string
function Version:to_string()
    return string.format('v%d.%d.%d', self.major, self.minor, self.patch)
end

function Version:__tostring()
    return self:to_string()
end
