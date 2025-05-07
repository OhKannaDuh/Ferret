using Ferret.Configs;
using Ferret.Models.Config;

namespace Ferret.Formatters
{
    public class ConfiguredTemplateFormatter : IFormatter<ConfiguredTemplate>
    {
        public string Format(ConfigOption<ConfiguredTemplate> option)
        {
            if (option.value.preset != null)
            {
                return $"local ferret = require(\"{option.value.preset.path}\")";
            }

            return $"local ferret = require(\"{option.value.template.path}\")";
        }
    }
}
