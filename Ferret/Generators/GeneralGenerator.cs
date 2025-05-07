using Ferret.Configs;
using Ferret.Models;
using ImGuiNET;

namespace Ferret.Generators;

public class GeneralGenerator : ILuaSectionGenerator
{
    public readonly TemplatesGenerator templates;

    public GeneralGenerator(ref TemplatesGenerator templates)
    {
        this.templates = templates;
    }

    public LuaScript Generate(LuaScript script)
    {
        if (!templates.GetConfigured().config.HasChanged())
        {
            return script;
        }

        var config = templates.template.value.template.config;
        if (templates.template.value.preset != null)
        {
            config = templates.template.value.preset.config;
        }

        script = script.AddLine("---General Config");

        foreach (var option in config.context.options.Values)
        {
            if (!option.hasChanged)
            {
                continue;
            }

            script = script.AddLine(option.Format());
        }

        return script;
    }

    public void Render()
    {
        ImGui.TextUnformatted(templates.GetConfigured().name);
        if (templates.template.value.preset != null)
        {
            templates.template.value.preset.Render();
            return;
        }

        templates.template.value.template.Render();
    }

    public void Reset()
    {
        templates.template.value.preset?.ResetOptions();
        templates.template.value.template.ResetOptions();
    }
}
