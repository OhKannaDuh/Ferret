--------------------------------------------------------------------------------
--   DESCRIPTION: Translatable string
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Translatable : Object
---@field en string
---@field de string
---@field fr string
---@field jp string
Translatable = Object:extend()

---@param en string
function Translatable:new(en)
    self.en = en
    self.de = en
    self.fr = en
    self.jp = en
end

---@param de string
---@return Translatable
function Translatable:with_de(de)
    self.de = de
    return self
end

---@param fr string
---@return Translatable
function Translatable:with_fr(fr)
    self.fr = fr
    return self
end

---@param jp string
---@return Translatable
function Translatable:with_jp(jp)
    self.jp = jp
    return self
end

---@return string #Return a string based on Ferret.language
function Translatable:get()
    if Ferret.language == 'de' then
        return self.de
    end
    if Ferret.language == 'fr' then
        return self.fr
    end
    if Ferret.language == 'jp' then
        return self.jp
    end

    return self.en
end
