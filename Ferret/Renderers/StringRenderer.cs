using System.Text;
using ECommons.ImGuiMethods;
using Ferret.Configs;
using ImGuiNET;

namespace Ferret.Renderers;

public class StringRenderer : Renderer<string>
{
    private readonly string label;

    private readonly int bufferSize;

    private readonly bool showClear = false;

    public StringRenderer(string label, int bufferSize = 256, bool showClear = false)
    {
        this.label = label;
        this.bufferSize = bufferSize;
        this.showClear = showClear;
    }

    public override void Render(ConfigOption<string> option)
    {
        ImGui.BeginGroup();

        if (showClear)
        {
            float generalWidth = ImGui.GetItemRectSize().X;

            if (ImGuiEx.IconButton(Dalamud.Interface.FontAwesomeIcon.Trash, "Clear"))
            {
                option.value = "";
            }
            ImGui.SameLine();

            // I have no idea why this is * 4
            ImGui.SetNextItemWidth(generalWidth - ImGui.GetItemRectSize().X * 4);
        }

        var buffer = new byte[bufferSize];
        var current = option.value ?? "";
        Encoding.UTF8.GetBytes(current, 0, current.Length, buffer, 0);

        if (ImGui.InputText(label, buffer, (uint)buffer.Length, ImGuiInputTextFlags.None))
        {
            option.value = Encoding.UTF8.GetString(buffer).TrimEnd('\0');
        }

        ImGui.EndGroup();

        Tooltip(option);
    }
}
