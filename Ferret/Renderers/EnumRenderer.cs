using System;
using System.Linq;
using Ferret.Configs;
using ImGuiNET;

namespace Ferret.Renderers;

public class EnumRenderer<T> : Renderer<T>
    where T : Enum
{
    private readonly string label;

    private readonly Func<T, string> formatter;

    public EnumRenderer(string label, Func<T, string> formatter)
    {
        this.label = label;
        this.formatter = formatter;
    }

    public override void Render(ConfigOption<T> option)
    {
        var values = Enum.GetValues(typeof(T)).Cast<T>().ToArray();
        var current = option.value;
        int currentIndex = Array.IndexOf(values, current);

        if (ImGui.BeginCombo(label, formatter(current)))
        {
            for (int i = 0; i < values.Length; i++)
            {
                bool isSelected = i == currentIndex;
                var displayName = formatter(values[i]);

                if (ImGui.Selectable(displayName, isSelected))
                {
                    option.value = values[i];
                }

                if (isSelected)
                {
                    ImGui.SetItemDefaultFocus();
                }
            }

            ImGui.EndCombo();
        }

        Tooltip(option);
    }
}
