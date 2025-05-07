using Ferret.Models.Presets;
using Ferret.Models.Templates;

namespace Ferret.Models.Config;

public class ConfiguredTemplate
{
    public Template template = new BlankTemplate();

    public Preset? preset;

    public ConfiguredTemplate Clone()
    {
        return new ConfiguredTemplate { template = template, preset = preset };
    }
}
