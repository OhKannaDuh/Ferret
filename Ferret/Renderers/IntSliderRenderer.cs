using ECommons.ImGuiMethods;
using Ferret.Configs;

namespace Ferret.Renderers;

public class IntSliderRenderer : Renderer<int>
{
    private readonly string label = "";

    private readonly int min;

    private readonly int max;

    public IntSliderRenderer(string label, int min, int max)
    {
        this.label = label;
        this.min = min;
        this.max = max;
    }

    public override void Render(ConfigOption<int> option)
    {
        int value = option.value;
        if (ImGuiEx.SliderInt(label, ref value, min, max))
        {
            option.value = value;
        }

        Tooltip(option);
    }
}
