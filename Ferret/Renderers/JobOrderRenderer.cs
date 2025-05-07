using System.Collections.Generic;
using ECommons.ImGuiMethods;
using Ferret.Configs;
using Ferret.Enums;
using Ferret.Models.Config;
using ImGuiNET;

namespace Ferret.Renderers;

public class JobOrderRenderer : IRenderer<JobOrder>
{
    private readonly string label;

    public JobOrderRenderer(string label)
    {
        this.label = label;
    }

    public void Render(ConfigOption<JobOrder> option)
    {
        ImGui.TextUnformatted(label);

        var keys = option.value.order;

        for (int i = 0; i < keys.Count; i++)
        {
            var job = keys[i];
            var toggle = option.value.jobs[job];

            ImGui.PushID(i);

            if (ImGuiEx.IconButton(Dalamud.Interface.FontAwesomeIcon.ArrowUp, $"Up##{i}") && i > 0)
            {
                Swap(keys, i, i - 1);
            }

            ImGui.SameLine();

            if (ImGuiEx.IconButton(Dalamud.Interface.FontAwesomeIcon.ArrowDown, $"Down##{i}") && i < keys.Count - 1)
            {
                Swap(keys, i, i + 1);
            }

            ImGui.SameLine();

            bool enabled = toggle.enabled;
            if (ImGui.Checkbox(toggle.name, ref enabled))
            {
                toggle.enabled = enabled;
            }

            ImGui.PopID();
        }
    }

    private void Swap(List<Job> list, int indexA, int indexB)
    {
        (list[indexA], list[indexB]) = (list[indexB], list[indexA]);
    }

    public void Tooltip(ConfigOption<JobOrder> _) { }
}
