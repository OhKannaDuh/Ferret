using Ferret.Configs;
using Ferret.Formatters;
using Ferret.Models;
using Ferret.Models.Config;
using Ferret.Renderers;

namespace Ferret.Generators;

public class TemplatesGenerator : ILuaSectionGenerator
{
    public ConfigManager config { get; } = new();

    public readonly ConfiguredTemplateConfig template;

    public TemplatesGenerator()
    {
        template = config.Create(
            "template",
            (context) =>
                (ConfiguredTemplateConfig)
                    new ConfiguredTemplateConfig(context, new ConfiguredTemplate())
                        .WithRenderer(new ConfiguredTemplateRenderer("Template"))
                        .WithFormatter(new ConfiguredTemplateFormatter())
                        .WithTooltip("")
        );
    }

    public LuaScript Generate(LuaScript script) => template.value.template.path == "" ? script : script.AddLine(template.Format());

    public void Render() => template.Render();

    public void Reset() => template.Reset();

    public ScriptProfile GetConfigured() => template.GetConfigured();
}
