using System.Collections.Generic;
using Ferret.Configs;
using Ferret.Enums;
using Ferret.Extensions;
using Ferret.Formatters;
using Ferret.Models.Presets;
using Ferret.Models.Presets.CosmicExploration.MissionFarmer;
using Ferret.Renderers;

namespace Ferret.Models.Templates.CosmicExploration;

public class MissionFarmer : Template
{
    public override string name => "Stellar Mission Farmer";

    public override string path => "Ferret/Templates/CosmicExploration/MissionFarmer";

    public override List<Preset> presets => [new PointFarm()];

    protected override void InitialiseConfig(ConfigManager config)
    {
        config.Create(
            "stop_on_failure",
            (context) =>
                (BoolConfig)
                    new BoolConfig(context, false)
                        .WithFormatter(new BoolFormatter("ferret.stop_on_failure"))
                        .WithRenderer(new BoolRenderer("Stop on Failure"))
                        .WithTooltip("")
        );

        config.Create(
            "mission_order",
            (context) =>
                (MissionOrderConfig)
                    new MissionOrderConfig(context, MissionOrder.TopPriority)
                        .WithRenderer(new EnumRenderer<MissionOrder>("Mission Order", v => v.ToFriendlyString()))
                        .WithFormatter(new EnumFormatter<MissionOrder>("ferret.mission_order", v => v.ToLuaEnum()))
                        .WithTooltip("")
        );

        var whitelist = config.Create(
            "whitelist",
            (context) =>
                (MissionSelectionConfig)
                    new MissionSelectionConfig(context, new Config.MissionSelection().Reorderable())
                        .WithRenderer(new MissionSelectionRenderer("Whitelist"))
                        .WithFormatter(new MissionSelectionFormatter("ferret.mission_list = CosmicExploration:create_mission_list_from_ids({", "})", 60))
                        .WithTooltip("")
        );

        var minimumAcceptable = CosmicExplorationConfigHelper.MinimumAcceptable(config);
        CosmicExplorationConfigHelper.PerMissionMinimumAcceptable(config, ref minimumAcceptable, ref whitelist);

        var targetResult = CosmicExplorationConfigHelper.TargetResult(config);
        CosmicExplorationConfigHelper.PerMissionTargetResult(config, ref targetResult, ref whitelist);
    }

    protected override void InitialiseExtensions(ExtensionManager extensions)
    {
        extensions.Add(new Repair());
        extensions.Add(new ExtractMateria());
        extensions.Add(new CraftingConsumables());
    }
}
