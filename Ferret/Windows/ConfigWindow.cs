using System;
using System.IO;
using Dalamud.Interface.Windowing;
using ECommons.DalamudServices;
using ImGuiNET;

namespace Ferret.Windows;

public class ConfigWindow : Window, IDisposable
{
    private Config config;

    public ConfigWindow(Plugin plugin)
        : base("Ferret Config##config")
    {
        config = plugin.config;
    }

    public void Dispose() { }

    public override void Draw()
    {
        string libPath = Path.Combine(Svc.PluginInterface.AssemblyLocation.Directory?.FullName!, "lib").Replace("\\", "/");
        ImGui.InputText("Library path", ref libPath, 256, ImGuiInputTextFlags.ReadOnly);

        string logsPath = Path.Combine(Svc.PluginInterface.AssemblyLocation.Directory?.FullName!, "logs").Replace("\\", "/");
        ImGui.InputText("Log path", ref logsPath, 256, ImGuiInputTextFlags.ReadOnly);
    }
}
