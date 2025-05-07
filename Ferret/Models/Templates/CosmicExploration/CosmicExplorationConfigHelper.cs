using Ferret.Configs;
using Ferret.Enums;
using Ferret.Formatters;
using Ferret.Models.Config;
using Ferret.Renderers;

namespace Ferret.Models.Templates.CosmicExploration;

public static class CosmicExplorationConfigHelper
{
    public static MissionResultConfig MinimumAcceptable(ConfigManager config)
    {
        return config.Create(
            "ce_minimum_acceptable",
            (context) =>
                (MissionResultConfig)
                    new MissionResultConfig(context, MissionResult.Gold)
                        .WithRenderer(new EnumRenderer<MissionResult>("Minimum Acceptable Result", v => v.ToFriendlyString()))
                        .WithFormatter(new EnumFormatter<MissionResult>("CosmicExploration.minimum_acceptable_result", v => v.ToLuaEnum()))
                        .WithTooltip("")
        );
    }

    public static MissionResultConfig TargetResult(ConfigManager config)
    {
        return config.Create(
            "ce_target_result",
            (context) =>
                (MissionResultConfig)
                    new MissionResultConfig(context, MissionResult.Gold)
                        .WithRenderer(new EnumRenderer<MissionResult>("Target Result", v => v.ToFriendlyString()))
                        .WithFormatter(new EnumFormatter<MissionResult>("CosmicExploration.minimum_target_result", v => v.ToLuaEnum()))
                        .WithTooltip("")
        );
    }

    public static MissionAssignmentConfig PerMissionMinimumAcceptable(
        ConfigManager config,
        ref MissionResultConfig result,
        ref MissionSelectionConfig selection
    )
    {
        var assignment = new MissionAssignment(ref result, ref selection);

        return config.Create(
            "ce_pre_mission_acceptable_result",
            (context) =>
                (MissionAssignmentConfig)
                    new MissionAssignmentConfig(context, assignment)
                        .WithRenderer(new MissionAssignmentRenderer("Per Mission Acceptable Result"))
                        .WithFormatter(new MissionAssignmentFormatter("CosmicExploration.per_mission_acceptable_result = {", "}"))
                        .WithTooltip("")
        );
    }

    public static MissionAssignmentConfig PerMissionTargetResult(ConfigManager config, ref MissionResultConfig result, ref MissionSelectionConfig selection)
    {
        var assignment = new MissionAssignment(ref result, ref selection);

        return config.Create(
            "ce_pre_mission_target_result",
            (context) =>
                (MissionAssignmentConfig)
                    new MissionAssignmentConfig(context, assignment)
                        .WithRenderer(new MissionAssignmentRenderer("Per Mission Target"))
                        .WithFormatter(new MissionAssignmentFormatter("CosmicExploration.per_mission_target_result = {", "}"))
                        .WithTooltip("")
        );
    }
}
