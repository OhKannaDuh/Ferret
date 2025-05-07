using Ferret.Configs;
using ImGuiNET;

namespace Ferret.Renderers;

public abstract class Renderer<T> : IRenderer<T>
    where T : notnull
{
    public abstract void Render(ConfigOption<T> option);

    protected void Tooltip(IConfigOption option)
    {
        if (!string.IsNullOrEmpty(option.tooltip) && ImGui.IsItemHovered())
        {
            ImGui.SetTooltip(option.tooltip);
        }
    }
}
