using Dalamud.Game.Command;
using Dalamud.Plugin;
using ECommons;
using ECommons.DalamudServices;
using Ferret.Managers;

namespace Ferret;

public sealed class Plugin : IDalamudPlugin
{
    internal string Name => "Ferret";

    private const string Command = "/ferret";

    public Config config { get; init; }

    private readonly WindowManager windows;

    public Plugin(IDalamudPluginInterface plugin)
    {
        ECommonsMain.Init(plugin, this);
        config = plugin.GetPluginConfig() as Config ?? new Config();

        Svc.Commands.AddHandler(Command, new CommandInfo(OnCommand) { HelpMessage = "Opens the ferret configurator." });

        windows = new WindowManager(this);

        windows.ToggleMainUI();
    }

    private void OnCommand(string command, string args)
    {
        windows.ToggleMainUI();
    }

    public void Dispose()
    {
        Svc.Commands.RemoveHandler(Command);

        windows.Dispose();

        ECommonsMain.Dispose();
    }
}
