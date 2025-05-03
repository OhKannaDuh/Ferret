local function require_translation(path)
    return require('Ferret/i18n/' .. path:gsub('%.', '/'))
end

return {
    en = require_translation('en'),
    de = require_translation('de'),
    fr = require_translation('fr'),
    jp = require_translation('jp'),
}
