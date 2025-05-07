using System.Text;
using ECommons.ImGuiMethods;
using Ferret.Configs;
using ImGuiNET;

namespace Ferret.Renderers;

public class StringRenderer : Renderer<string>
{
    private readonly string label;

    private readonly uint bufferSize;

    private readonly bool readOnly = false;

    public StringRenderer(string label, uint bufferSize = 256, bool readOnly = false)
    {
        this.label = label;
        this.bufferSize = bufferSize;
        this.readOnly = readOnly;
    }

    public override void Render(ConfigOption<string> option)
    {
        ImGui.BeginGroup();

        var buffer = new byte[bufferSize];
        var current = option.value ?? "";
        Encoding.UTF8.GetBytes(current, 0, current.Length, buffer, 0);

        var flags = readOnly ? ImGuiInputTextFlags.ReadOnly : ImGuiInputTextFlags.None;
        if (ImGui.InputText(label, buffer, (uint)buffer.Length, flags))
        {
            option.value = Encoding.UTF8.GetString(buffer).TrimEnd('\0');
        }

        ImGui.EndGroup();

        Tooltip(option);
    }
}
