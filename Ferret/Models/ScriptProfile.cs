using System.Collections.Generic;
using System.Linq;
using ECommons;
using Ferret.Configs;
using Ferret.Extensions;
using Ferret.UI;
using ImGuiNET;

namespace Ferret.Models;

public abstract class ScriptProfile
{
    public abstract string name { get; }

    public abstract string path { get; }

    public ExtensionManager extensions { get; } = new();

    public ConfigManager config { get; } = new();

    public virtual List<List<string>> layout => [];

    public virtual void ResetOptions() => config.context.options.Values.Each(o => o.Reset());

    public virtual void CopyFrom(ScriptProfile source)
    {
        foreach (var (key, targetOption) in config.context.options)
        {
            if (source.config.context.TryGet<IConfigOption>(key, out var sourceOption))
            {
                if (targetOption.GetType() == sourceOption?.GetType())
                {
                    targetOption.CopyValueFrom(sourceOption);
                }
            }
        }
    }

    public virtual void Render()
    {
        // Default rendering
        if (layout.Count() <= 0)
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
}
