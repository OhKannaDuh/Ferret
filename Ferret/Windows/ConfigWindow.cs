using System;
using System.Numerics;
using Dalamud.Interface.Windowing;
using ImGuiNET;

namespace Ferret.Windows;

public class ConfigWindow : Window, IDisposable
{
    private Config config;

    public ConfigWindow(Plugin plugin)
        : base("Ferret Config##config")
    {
        Flags = ImGuiWindowFlags.NoResize | ImGuiWindowFlags.NoCollapse | ImGuiWindowFlags.NoScrollbar | ImGuiWindowFlags.NoScrollWithMouse;

        Size = new Vector2(232, 90);
        SizeCondition = ImGuiCond.Always;

        config = plugin.config;
    }

    public void Dispose() { }

    public override void Draw() { }
}
