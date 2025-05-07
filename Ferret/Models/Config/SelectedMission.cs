using Ferret.Models.Data.CosmicExploration;

namespace Ferret.Models.Config;

public class SelectedMission
{
    public Mission mission { get; set; }
    public bool selected { get; set; } = false;

    public SelectedMission(Mission mission)
    {
        this.mission = mission;
    }
}
