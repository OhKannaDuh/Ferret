using System;
using System.Numerics;
using Dalamud.Interface.Utility.Raii;
using Dalamud.Interface.Windowing;
using Ferret.Generators;
using Ferret.Models;
using Ferret.UI;
using Ferret.Windows.Panels.Main;
using ImGuiNET;

namespace Ferret.Windows;

public class MainWindow : Window, IDisposable
{
    private Plugin plugin;

    private ConfigPanel config = new();

    private EditorPanel editor = new();

    public MainWindow(Plugin plugin)
        : base("Ferret##main", ImGuiWindowFlags.NoScrollbar | ImGuiWindowFlags.NoScrollWithMouse)
    {
        SizeConstraints = new WindowSizeConstraints { MinimumSize = new Vector2(375, 330), MaximumSize = new Vector2(float.MaxValue, float.MaxValue) };

        this.plugin = plugin;
    }

    public void Dispose() { }

    public override void Draw()
    {
        using var table = ImRaii.Table("FerretTable", 2, ImGuiTableFlags.SizingStretchSame | ImGuiTableFlags.Resizable);
        if (!table)
        {
            return;
        }

        editor.text = config.Generate(new LuaScript()).ToString();

        ImGui.TableNextColumn();
        config.Render();

        ImGui.TableNextColumn();
        editor.Render();
    }
}
