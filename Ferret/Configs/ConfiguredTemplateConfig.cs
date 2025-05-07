using System.Linq;
using Ferret.Collections;
using Ferret.Models;
using Ferret.Models.Config;

namespace Ferret.Configs;

public class ConfiguredTemplateConfig : ConfigOption<ConfiguredTemplate>
{
    public ConfiguredTemplateConfig(ConfigContext context, ConfiguredTemplate value)
        : base(context, value)
    {
        this.value = value.Clone();
    }

    public override bool hasChanged => value.template.path != original.template.path;

    public override void Reset()
    {
        base.Reset();
        value = value.Clone();
    }

    public ScriptProfile GetConfigured() => value.preset != null ? value.preset : value.template;
}
