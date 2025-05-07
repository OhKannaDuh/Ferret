using System.Runtime.CompilerServices;
using Ferret.Configs;
using Ferret.Models.Config;
using ImGuiNET;

namespace Ferret.Renderers;

public class ItemSelectionRenderer : IRenderer<ItemSelection>
{
    private readonly string label;

    public ItemSelectionRenderer(string label)
    {
        this.label = label;
    }

    public void Render(ConfigOption<ItemSelection> option)
    {
        // Checkbox
        var hq = option.value.hq;
        if (ImGui.Checkbox($"HQ?##{label}", ref hq))
            option.value.hq = hq;

        ImGui.SameLine();

        // Combo dropdown aligned with other inputs
        ImGui.PushItemWidth(ImGui.CalcItemWidth() - ImGui.GetCursorPosX());
        if (ImGui.BeginCombo($"{label}##dropdown", option.value.selected))
        {
            foreach (var item in option.value.items)
            {
                if (ImGui.Selectable(item.name))
                    option.value.selected = item.name;
            }
            ImGui.EndCombo();
        }
        ImGui.PopItemWidth();
    }
}
