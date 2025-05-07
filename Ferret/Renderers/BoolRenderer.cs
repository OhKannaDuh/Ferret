using Ferret.Configs;
using ImGuiNET;

namespace Ferret.Renderers;

public class BoolRenderer : Renderer<bool>
{
    private readonly string label;

    public BoolRenderer(string label)
    {
        this.label = label;
    }

    public override void Render(ConfigOption<bool> option)
    {
        var value = option.value;
        if (ImGui.Checkbox(label, ref value))
        {
            option.value = value;
        }

        Tooltip(option);
    }
}
