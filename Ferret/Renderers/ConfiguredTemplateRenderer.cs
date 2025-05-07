using System;
using System.Linq;
using Ferret.Collections;
using Ferret.Configs;
using Ferret.Models.Config;
using ImGuiNET;

namespace Ferret.Renderers
{
    public class ConfiguredTemplateRenderer : Renderer<ConfiguredTemplate>
    {
        private readonly string label;

        private readonly TemplateCollection templates = new();

        public ConfiguredTemplateRenderer(string label)
        {
            this.label = label;
        }

        public override void Render(ConfigOption<ConfiguredTemplate> option)
        {
            var current = option.value.template;
            var currentIndex = Math.Max(templates.ToList().IndexOf(current), 0);

            if (ImGui.BeginCombo(label, templates.ElementAt(currentIndex).name)) // Use ElementAt for IEnumerable
            {
                int i = 0;
                foreach (var template in templates)
                {
                    bool isSelected = i == currentIndex;
                    if (ImGui.Selectable(template.name, isSelected))
                    {
                        option.value.template = template;
                    }

                    if (isSelected)
                    {
                        ImGui.SetItemDefaultFocus();
                    }

                    i++;
                }

                ImGui.EndCombo();
            }

            // Render Preset ComboBox if the selected template has presets
            if (current?.presets != null && current.presets.Any())
            {
                if (ImGui.BeginCombo("Select Preset (optional)", option.value.preset?.name ?? "None"))
                {
                    if (ImGui.Selectable("None", option.value.preset == null))
                    {
                        option.value.preset = null;
                    }

                    foreach (var preset in current.presets)
                    {
                        bool isSelected = option.value.preset == preset;
                        if (ImGui.Selectable(preset.name, isSelected))
                        {
                            option.value.preset = preset;
                        }

                        if (isSelected)
                        {
                            ImGui.SetItemDefaultFocus();
                        }
                    }
                    ImGui.EndCombo();
                }
            }

            Tooltip(option);
        }
    }
}
