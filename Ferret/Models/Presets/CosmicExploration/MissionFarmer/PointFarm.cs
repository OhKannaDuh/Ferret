using System.Collections.Generic;
using ECommons.DalamudServices;
using Ferret.Configs;
using Ferret.Enums;
using Ferret.Extensions;
using Ferret.Models.Templates.CosmicExploration;

namespace Ferret.Models.Presets.CosmicExploration.MissionFarmer;

public class PointFarm : Preset
{
    public override string name => "Stellar Mission Point Farmer";

    public override string path => "Ferret/Presets/CosmicExploration/MissionFarmer/PointFarm";

    protected override void InitialiseConfig(ConfigManager config)
    {
        CosmicExplorationConfigHelper.MinimumAcceptable(config);
        CosmicExplorationConfigHelper.TargetResult(config);
    }

    protected override void InitialiseExtensions(ExtensionManager extensions)
    {
        extensions.Add(new Repair());
        extensions.Add(new ExtractMateria());
        extensions.Add(new CraftingConsumables());
    }
}
