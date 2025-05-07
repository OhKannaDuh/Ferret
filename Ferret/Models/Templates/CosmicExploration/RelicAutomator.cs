using System.Collections.Generic;
using ECommons.DalamudServices;
using Ferret.Configs;
using Ferret.Enums;
using Ferret.Extensions;
using Ferret.Formatters;
using Ferret.Models.Config;
using Ferret.Renderers;

namespace Ferret.Models.Templates.CosmicExploration;

public class RelicAutomator : Template
{
    public override string name => "Cosmic Relic Automator";

    public override string path => "Ferret/Templates/CosmicExploration/RelicAutomator";

    protected override void InitialiseConfig(ConfigManager config)
    {
        config.Create(
            "job_order",
            (context) =>
                (JobOrderConfig)
                    new JobOrderConfig(context, JobOrder.Crafters())
                        .WithRenderer(new JobOrderRenderer("Job Order"))
                        .WithFormatter(new JobOrderFormatter("ferret.job_order = {", "}", v => v.ToLuaEnum()))
                        .WithTooltip("")
        );

        config.Create(
            "auto_blacklist",
            (context) =>
                (BoolConfig)
                    new BoolConfig(context, false)
                        .WithFormatter(new BoolFormatter("ferret.auto_blacklist"))
                        .WithRenderer(new BoolRenderer("Auto Blacklist:"))
                        .WithTooltip("")
        );

        config.Create(
            "blacklist",
            (context) =>
                (MissionSelectionConfig)
                    new MissionSelectionConfig(context, new MissionSelection())
                        .WithRenderer(new MissionSelectionRenderer("Blacklist"))
                        .WithFormatter(new MissionSelectionFormatter("ferret.blacklist = CosmicExploration:create_mission_list_from_ids({", "})", 60))
                        .WithTooltip("")
        );

        CosmicExplorationConfigHelper.MinimumAcceptable(config);
        CosmicExplorationConfigHelper.TargetResult(config);
    }

    protected override void InitialiseExtensions(ExtensionManager extensions)
    {
        extensions.Add(new Repair());
        extensions.Add(new ExtractMateria());
        extensions.Add(new CraftingConsumables());
    }

    private Dictionary<Job, ToggleItem> GetDefaultJobOrder()
    {
        return new Dictionary<Job, ToggleItem>
        {
            { Job.Carpenter, new ToggleItem(Job.Carpenter.ToFriendlyString()) },
            { Job.Blacksmith, new ToggleItem(Job.Blacksmith.ToFriendlyString()) },
            { Job.Armorer, new ToggleItem(Job.Armorer.ToFriendlyString()) },
            { Job.Goldsmith, new ToggleItem(Job.Goldsmith.ToFriendlyString()) },
            { Job.Leatherworker, new ToggleItem(Job.Leatherworker.ToFriendlyString()) },
            { Job.Weaver, new ToggleItem(Job.Weaver.ToFriendlyString()) },
            { Job.Alchemist, new ToggleItem(Job.Alchemist.ToFriendlyString()) },
            { Job.Culinarian, new ToggleItem(Job.Culinarian.ToFriendlyString()) },
        };
    }
}
