using System.Collections.Generic;
using System.Linq;
using Ferret.Configs;

namespace Ferret.Models.Config;

public class MissionAssignment
{
    public List<MissionResultMapping> missions = [];

    public MissionResultConfig result;

    public MissionSelectionConfig selection;

    public MissionAssignment(ref MissionResultConfig result, ref MissionSelectionConfig selection)
    {
        this.result = result;
        this.selection = selection;
    }

    public MissionAssignment Clone()
    {
        return new MissionAssignment(ref result!, ref selection!)
        {
            missions = this.missions.Select(m => new MissionResultMapping(m.mission) { result = m.result }).ToList(),
        };
    }
}
