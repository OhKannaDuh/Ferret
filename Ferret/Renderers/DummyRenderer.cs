using System.Text;
using ECommons.ImGuiMethods;
using Ferret.Configs;
using ImGuiNET;

namespace Ferret.Renderers;

public class DummyRenderer<T> : Renderer<T>
    where T : notnull
{
    public override void Render(ConfigOption<T> option)
    {
        ImGui.TextUnformatted("---Dummy Renderer in use---");
    }
}
