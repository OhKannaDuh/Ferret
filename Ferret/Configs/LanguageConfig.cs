using Ferret.Enums;
using Ferret.Formatters;
using Ferret.Renderers;

namespace Ferret.Configs;

public class LanguageConfig : ConfigOption<Language>
{
    public LanguageConfig(ConfigContext context, Language value)
        : base(context, value) { }
}
