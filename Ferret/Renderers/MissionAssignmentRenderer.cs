using System;
using System.Collections.Generic;
using System.Linq;
using ECommons.DalamudServices;
using Ferret.Configs;
using Ferret.Enums;
using Ferret.Models.Config;
using Ferret.Models.Data.CosmicExploration;
using ImGuiNET;

namespace Ferret.Renderers
{
    public class MissionAssignmentRenderer : IRenderer<MissionAssignment>
    {
        private readonly string label;

        public MissionAssignmentRenderer(string label)
        {
            this.label = label;
        }

        public void Render(ConfigOption<MissionAssignment> option)
        {
            var selection = option.value.selection.value;
            if (selection.selectedOrder.Count <= 0)
            {
                return;
            }

            // Display the label for the group
            ImGui.TextUnformatted(label);

            int numSelectedMissions = selection.missions.Count(mission => mission.selected);

            // Approximate the height for 5 combo boxes
            float itemHeight = ImGui.GetFrameHeightWithSpacing();
            float maxHeight = itemHeight * 5; // Max height for 5 items

            // Ensure that the child height is dynamically set based on the number of missions
            float childHeight = Math.Min(maxHeight, itemHeight * numSelectedMissions); // Limit to max 5 items, otherwise scrollable

            if (ImGui.BeginChild($"##{label}-MissionResultChild", new System.Numerics.Vector2(0, childHeight), true, ImGuiWindowFlags.HorizontalScrollbar))
            {
                // Iterate over all missions in the selection
                foreach (var missionData in selection.missions)
                {
                    // Only process selected missions
                    if (!missionData.selected)
                        continue;

                    // Find the corresponding MissionResultMapping in the MissionAssignment's missions list
                    var missionResultMapping = option.value.missions.FirstOrDefault(mapping => mapping.mission == missionData.mission);

                    // If no mapping exists, we use the default value from `option.value.result.value`
                    if (missionResultMapping == null)
                    {
                        missionResultMapping = new MissionResultMapping(missionData.mission)
                        {
                            result = option.value.result?.value ?? MissionResult.Gold, // Default to Gold if result is null
                        };
                        // Add the new MissionResultMapping to the list
                        option.value.missions.Add(missionResultMapping);
                    }

                    // Draw combo box for mission result and mission name next to it
                    string[] resultOptions = Enum.GetNames(typeof(MissionResult));

                    // Set the combo box width (1/4 of available width)
                    float comboWidth = ImGui.GetContentRegionAvail().X * 0.25f;
                    ImGui.PushItemWidth(comboWidth); // Set combo box width

                    // Create the combo box
                    int selectedResult = (int)missionResultMapping.result;
                    if (ImGui.Combo($"##{label}-{missionData.mission.GetLabel()}", ref selectedResult, resultOptions, resultOptions.Length))
                    {
                        // Update the result for the mission if the selection changes
                        missionResultMapping.result = (MissionResult)selectedResult;
                    }

                    ImGui.PopItemWidth(); // Reset the item width

                    // Display the mission name next to the combo box
                    ImGui.SameLine();
                    ImGui.Text(missionData.mission.GetLabel());
                }

                // End the scrollable child window
                ImGui.EndChild();
            }
        }
    }
}
