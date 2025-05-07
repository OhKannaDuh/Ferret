using System.Linq;
using Ferret.Models.Config;

namespace Ferret.Configs;

public class MissionAssignmentConfig : ConfigOption<MissionAssignment>
{
    public override bool hasChanged => value.missions.Any(mission => mission.result != value.result.value);

    public MissionAssignmentConfig(ConfigContext context, MissionAssignment value)
        : base(context, value.Clone())
    {
        this.value = value;
    }

    public void WatchResult(ref MissionResultConfig result)
    {
        this.value.result = result;
    }

    public void WatchSelection(ref MissionSelectionConfig selection)
    {
        this.value.selection = selection;
    }
}
