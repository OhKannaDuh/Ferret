using System.Collections.Generic;
using Ferret.Configs;
using Ferret.UI;
using ImGuiNET;

namespace Ferret.Extensions;

public abstract class Extension : IExtension
{
    public abstract string name { get; }

    public abstract string file { get; }

    public abstract string key { get; }

    public bool enabled { get; set; } = false;

    public ConfigManager config { get; } = new();

    public virtual List<List<string>> layout => [];

    public bool hasChanged => config.HasChanged();

    public Extension()
    {
        InitialiseConfig(config);
    }

    protected abstract void InitialiseConfig(ConfigManager config);

    public virtual void Render()
    {
        if (config.context.options.Count <= 0)
        {
            return;
        }

        ImGui.TextUnformatted($"{name} Config");

        // Default rendering
        if (layout.Count <= 0)
        {
            foreach (var option in config.context.options.Values)
            {
                option.Render();
            }

            return;
        }

        // Custom rendering
        foreach (List<string> row in layout)
        {
            foreach (string key in row)
            {
                if (key == "_SEPARATOR")
                {
                    FerretGui.Separator();

                    continue;
                }

                if (config.context.options.TryGetValue(key, out var opt))
                {
                    opt.Render();
                    ImGui.SameLine();
                }
            }

            ImGui.NewLine();
        }
    }

    public string Format()
    {
        string formatted = config.HasChanged() ? "\n" : "";
        foreach (var option in config.context.options.Values)
        {
            if (!option.hasChanged)
            {
                continue;
            }

            formatted += option.Format() + "\n";
        }

        return formatted;
    }

    public virtual void Reset() { }
}
