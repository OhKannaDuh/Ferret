using System.Linq;
using ECommons.ImGuiMethods;
using Ferret.Configs;
using Ferret.Enums;
using Ferret.Models.Config;
using Ferret.UI;
using ImGuiNET;
using Microsoft.VisualBasic;

namespace Ferret.Renderers;

public class MissionSelectionRenderer : IRenderer<MissionSelection>
{
    private readonly string label;

    public MissionSelectionRenderer(string label)
    {
        this.label = label;
    }

    public void Render(ConfigOption<MissionSelection> option)
    {
        ImGui.TextUnformatted(label);

        var selected = option.value.GetSelected().ToList();
        var count = selected.Count();

        var filtered = option.value.GetFiltered().ToList();

        if (ImGui.BeginCombo("Mission Select", $"Selected ({count})", ImGuiComboFlags.HeightLarge))
        {
            // Search box
            ImGui.InputText("Search", ref option.value.search, 100);
            JobFilter(option);
            FerretGui.Separator();
            ImGui.TextUnformatted(""); // Blank line

            for (var i = 0; i < option.value.selectedOrder.Count; i++)
            {
                var missionIndex = option.value.selectedOrder[i];

                if (missionIndex < 0 || missionIndex >= option.value.missions.Count)
                    continue;

                var item = option.value.missions[missionIndex];

                ImGui.PushID($"SelectedItem{i}");

                bool isSelected = item.selected;
                if (ImGui.Checkbox(item.mission.GetLabel(), ref isSelected))
                {
                    option.value.selectedOrder.RemoveAt(i);
                    item.selected = isSelected;
                    option.TriggerChange();
                    i--; // Adjust loop since we removed current index
                    ImGui.PopID();
                    continue;
                }

                if (option.value.reorderable)
                {
                    if (ImGui.BeginDragDropSource())
                    {
                        ImGuiDragDrop.SetDragDropPayload("REORDER_ITEM", i);
                        ImGui.Text(item.mission.GetLabel());
                        ImGui.EndDragDropSource();
                    }

                    if (ImGui.BeginDragDropTarget())
                    {
                        if (ImGuiDragDrop.AcceptDragDropPayload("REORDER_ITEM", out int index))
                        {
                            option.value.SwapItemOrder(index, i);
                            option.TriggerChange();
                        }

                        ImGui.EndDragDropTarget();
                    }
                }

                ImGui.PopID();
            }

            if (count > 0)
            {
                FerretGui.Separator();
                ImGui.TextUnformatted(""); // Blank line
            }

            for (var i = 0; i < filtered.Count; i++)
            {
                var item = filtered[i];

                ImGui.PushID($"UnselectedItem{i}");
                bool isSelected = item.selected;
                if (ImGui.Checkbox(item.mission.GetLabel(), ref isSelected))
                {
                    var originalIndex = option.value.missions.IndexOf(item);
                    if (originalIndex != -1 && !option.value.selectedOrder.Contains(originalIndex))
                    {
                        option.value.selectedOrder.Add(originalIndex);
                    }

                    item.selected = isSelected;
                    option.TriggerChange();
                }

                ImGui.PopID();
            }

            ImGui.EndCombo();
        }
    }

    private void JobFilter(ConfigOption<MissionSelection> option)
    {
        if (ImGui.BeginCombo("Job Filter", option.value.selectedFilter.ToFriendlyString(), ImGuiComboFlags.HeightLarge))
        {
            foreach (var filter in option.value.filterOptions)
            {
                if (ImGui.Selectable(filter.ToFriendlyString(), filter!.Equals(option.value.selectedFilter)))
                {
                    option.value.selectedFilter = filter;
                }
            }

            ImGui.EndCombo();
        }
    }
}
