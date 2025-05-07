using System.Linq;
using Ferret.Configs;
using Ferret.Models;
using ImGuiNET;

namespace Ferret.Generators;

public class ExtensionsGenerator : ILuaSectionGenerator
{
    public readonly TemplatesGenerator templates;

    public ExtensionsGenerator(ref TemplatesGenerator templates)
    {
        this.templates = templates;
    }

    public ConfigManager config { get; } = new();

    public LuaScript Generate(LuaScript script)
    {
        var template = templates.GetConfigured();
        var enabled = template.extensions.Enabled();
        var changed = template.extensions.Changed();

        if (enabled.Count() > 0)
        {
            script = script.NewLine().AddLine("---Extensions");
            var unchanged = template.extensions.Unchanged();
            if (unchanged.Count() > 0)
            {
                var unchangedNames = string.Join(", ", unchanged.Select(e => $"\"{e.file}\""));
                script = script.AddLine($"ExtensionManager:load({unchangedNames})");
            }

            if (changed.Count() > 0)
            {
                var changedNames = string.Join(", ", changed.Select(e => $"\"{e.file}\""));
                var changedKeys = string.Join(", ", changed.Select(e => $"{e.key}"));
                script = script.AddLine($"local {changedKeys} = ExtensionManager:load({changedNames})").NewLine();
            }
        }

        foreach (var extension in changed)
        {
            if (!extension.hasChanged)
            {
                continue;
            }

            script = script.AddLine(extension.Format());
        }

        return script;
    }

    public void Render()
    {
        var template = templates.GetConfigured();
        var enabledCount = template.extensions.Enabled().Count();
        var max = template.extensions.extensions.Count();
        if (ImGui.BeginCombo("Extensions", $"Extensions ({enabledCount}/{max})"))
        {
            foreach (var extension in template.extensions.extensions)
            {
                var enabled = extension.enabled;
                if (ImGui.Selectable(extension.name, ref enabled))
                {
                    extension.enabled = enabled;
                }
            }

            ImGui.EndCombo();
        }

        foreach (var extension in template.extensions.Enabled())
        {
            extension.Render();
        }
    }

    public void Reset() { }
}
