--------------------------------------------------------------------------------
--   DESCRIPTION: Base Template
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

require('Ferret/FerretCore')

---@class Template : FerretCore, Translation
Template = FerretCore:extend()
Template:implement(Translation)

function Template:new(key, version)
    Template.super.new(self, i18n('templates.' .. key .. '.name'))
    self.translation_path = 'templates.' .. key
    self.template_version = version
end

function Template:init()
    FerretCore.init(self)

    Logger:info_t('version', { name = self.name, version = self.template_version })

    return self
end

return Template
