using System;
using System.Collections.Generic;
using System.Linq;
using ECommons.DalamudServices;
using ECommons.ImGuiMethods;
using ImGuiNET;

namespace Ferret.UI;

public static class FerretGui
{
    public static void Separator()
    {
        ImGui.Spacing();
        ImGui.Separator();
        ImGui.Spacing();
    }

    public static bool ConfiguratorHeader(string label)
    {
        ImGui.TextUnformatted(label);

        float buttonWidth = ImGui.CalcTextSize("\uf01e").X + ImGui.GetStyle().FramePadding.X * 2;
        ImGui.SameLine(ImGui.GetContentRegionAvail().X - buttonWidth - ImGui.GetStyle().ItemSpacing.X);

        return ImGuiEx.IconButton(Dalamud.Interface.FontAwesomeIcon.Redo, $"{label}##Reset");
    }

    public static void MultiSelectComboBox<T, F>(string itemLabel, string filterLabel, ref MultiSelectComboBoxState<T, F> state)
        where T : IMultiSelectable
        where F : Enum?
    {
        var count = state.items.Where(m => m.IsSelected()).Count().ToString();

        if (ImGui.BeginCombo(itemLabel, $"Selected ({count})", ImGuiComboFlags.HeightLargest))
        {
            // Search box
            ImGui.InputText("Search", ref state.term, 100);

            if (ImGui.BeginCombo(filterLabel, state.selectedFilter?.ToString() ?? "None", ImGuiComboFlags.HeightLargest))
            {
                // Render filter options
                foreach (var filterOption in state.filterOptions)
                {
                    bool isSelected = filterOption!.Equals(state.selectedFilter);
                    if (ImGui.Selectable(state.getFilterOptionName(filterOption), isSelected))
                    {
                        state.selectedFilter = filterOption;
                    }
                }
                ImGui.EndCombo();
            }

            if (state.items.Any(m => m.IsSelected()))
            {
                FerretGui.Separator();
            }

            for (var i = 0; i < state.selectedItemOrder.Count; i++)
            {
                int itemIndex = state.selectedItemOrder[i];
                var item = state.items[itemIndex];

                if (!item.IsSelected())
                {
                    continue;
                }

                ImGui.PushID($"SelectedItem{i}");

                bool selected = item.IsSelected();
                if (ImGui.Checkbox(item.GetLabel(), ref selected))
                {
                    item.SetIsSelected(false);
                }

                if (state.reorderable)
                {
                    // Enable drag-and-drop for reordering
                    if (ImGui.BeginDragDropSource())
                    {
                        // Set the payload (the index of the item to be dragged)
                        ImGuiDragDrop.SetDragDropPayload("REORDER_ITEM", i);
                        ImGui.Text(item.GetLabel());
                        ImGui.EndDragDropSource();
                    }

                    if (ImGui.BeginDragDropTarget())
                    {
                        if (ImGuiDragDrop.AcceptDragDropPayload("REORDER_ITEM", out int index))
                        {
                            state.SwapItemOrder(index, i);
                        }

                        ImGui.EndDragDropTarget();
                    }
                }
            }

            FerretGui.Separator();

            var _selectedFilter = state.selectedFilter;
            var filterBy = state.filterBy;
            var filtered = state.items.Where(v => filterBy(v, _selectedFilter));

            var _term = state.term;
            filtered = filtered.Where(item => item.GetLabel().Contains(_term, StringComparison.OrdinalIgnoreCase)).ToList();

            // Render disabled items
            for (var i = 0; i < filtered.Count(); i++)
            {
                var item = filtered.ToList()[i];

                if (item.IsSelected())
                {
                    continue;
                }

                ImGui.PushID($"D{i}");
                bool selected = item.IsSelected();
                if (ImGui.Checkbox(item.GetLabel(), ref selected))
                {
                    state.selectedItemOrder.Add(i);
                    item.SetIsSelected(true);
                }
            }

            ImGui.EndCombo();
        }
    }
}
