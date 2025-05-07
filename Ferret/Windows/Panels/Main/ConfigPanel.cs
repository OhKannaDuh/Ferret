using ECommons.DalamudServices;
using Ferret.Collections.CosmicExploration;
using Ferret.Generators;
using Ferret.Models;
using Ferret.UI;
using ImGuiNET;

namespace Ferret.Windows.Panels.Main;

public class ConfigPanel
{
    private FoodCollection food = new();

    private MedicineCollection medicine = new();

    private GlobalsGenerator globals = new();

    private TemplatesGenerator templates = new();

    private ExtensionsGenerator extensions;

    private GeneralGenerator general;

    private StartGenerator start = new();

    public ConfigPanel()
    {
        general = new(ref templates);
        extensions = new(ref templates);
    }

    public void Render()
    {
        var height = ImGui.GetWindowSize().Y;
        if (ImGui.BeginChild("##ConfigPanelScroll"))
        {
            if (FerretGui.ConfiguratorHeader("Global Configuration:"))
            {
                globals.Reset();
            }

            globals.Render();

            FerretGui.Separator();
            if (FerretGui.ConfiguratorHeader("Template Configuration:"))
            {
                templates.Reset();
                extensions.Reset();
                general.Reset();
            }

            templates.Render();

            if (!templates.template.hasChanged)
            {
                ImGui.EndChild();
                return;
            }

            if (templates.GetConfigured().extensions.extensions.Count > 0)
            {
                FerretGui.Separator();
                if (FerretGui.ConfiguratorHeader("Extension Configuration:"))
                {
                    extensions.Reset();
                }

                extensions.Render();
            }

            FerretGui.Separator();
            if (FerretGui.ConfiguratorHeader("General Configuration:"))
            {
                general.Reset();
            }

            general.Render();

            ImGui.EndChild();
        }
    }

    public LuaScript Generate(LuaScript script)
    {
        if (!templates.template.hasChanged)
        {
            return script;
        }

        script = globals.Generate(script);
        script = templates.Generate(script);
        script = extensions.Generate(script);
        script = general.Generate(script);
        script = start.Generate(script);

        return script;
    }
}
