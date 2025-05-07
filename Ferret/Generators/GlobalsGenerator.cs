using System.IO;
using ECommons.DalamudServices;
using Ferret.Configs;
using Ferret.Enums;
using Ferret.Formatters;
using Ferret.Models;
using Ferret.Renderers;
using ImGuiNET;

namespace Ferret.Generators;

public class GlobalsGenerator : ILuaSectionGenerator
{
    public ConfigManager config { get; } = new();

    public readonly BoolConfig debug;

    public readonly StringConfig logDirectory;

    public readonly BoolConfig fileOnly;

    public readonly LanguageConfig language;

    public GlobalsGenerator()
    {
        debug = config.Create(
            "debug",
            (context) =>
                (BoolConfig)
                    new BoolConfig(context, false)
                        .WithRenderer(new BoolRenderer("Debug"))
                        .WithFormatter(new BoolFormatter("_debug"))
                        .WithTooltip("Tell the logger to log debug messages.")
        );

        string logsPath = Path.Combine(Svc.PluginInterface.AssemblyLocation.Directory?.FullName!, "logs").Replace("\\", "/");
        logDirectory = config.Create(
            "log_directory",
            (context) =>
                (StringConfig)
                    new StringConfig(context, logsPath)
                        .WithRenderer(new StringRenderer("Log Directory", 1024, true))
                        .WithFormatter(new StringFormatter("_log_directory"))
                        .WithTooltip("A directory whee log files should be stored. (Must exist)")
        );

        fileOnly = config.Create(
            "file_only",
            (context) =>
                (BoolConfig)
                    new BoolConfig(context, false)
                        .WithRenderer(new BoolRenderer("File Only"))
                        .WithFormatter(new BoolFormatter("_file_only"))
                        .WithTooltip("Used with Log Directory, will prevent logs being sent to /echo.")
        );

        language = config.Create(
            "_language",
            (context) =>
                (LanguageConfig)
                    new LanguageConfig(context, Language.EN)
                        .WithRenderer(new EnumRenderer<Language>("Language", v => v.ToFriendlyString()))
                        .WithFormatter(new EnumFormatter<Language>("_language", v => v.ToFriendlyString()))
                        .WithTooltip("Game client language. (Warning: non-English clients are not supported across the board)")
        );
    }

    public LuaScript Generate(LuaScript script)
    {
        bool hasChanged = false;

        if (debug.hasChanged)
        {
            hasChanged = true;
            script = script.AddLine(debug.Format());
            script = script.AddLine(logDirectory.Format());
        }

        if (fileOnly.hasChanged && logDirectory.hasChanged)
        {
            hasChanged = true;
            script = script.AddLine(fileOnly.Format());
        }

        if (language.hasChanged)
        {
            hasChanged = true;
            script = script.AddLine(language.Format());
        }

        return hasChanged ? script.NewLine() : script;
    }

    public void Render()
    {
        language.Render();
        logDirectory.Render();

        if (ImGui.BeginTable("GlobalsGenerator_checkboxes", 2, ImGuiTableFlags.SizingStretchSame))
        {
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            debug.Render();

            if (logDirectory.hasChanged)
            {
                ImGui.TableSetColumnIndex(1);
                fileOnly.Render();
            }

            ImGui.EndTable();
        }
    }

    public void Reset()
    {
        debug.Reset();
        logDirectory.Reset();
        fileOnly.Reset();
        language.Reset();
    }
}
