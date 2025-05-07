using Ferret.Enums;
using Ferret.Models.Data.CosmicExploration;

namespace Ferret.Models.Config;

public class MissionResultMapping
{
    public Mission mission { get; set; }

    public MissionResult result = MissionResult.Gold;

    public MissionResultMapping(Mission mission)
    {
        this.mission = mission;
    }
}
