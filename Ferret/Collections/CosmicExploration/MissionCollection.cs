using ECommons.DalamudServices;
using Ferret.Models.Data.CosmicExploration;
using Lumina.Excel.Sheets;

namespace Ferret.Collections.CosmicExploration;

public class MissionCollection : Collection<Mission, uint>
{
    public MissionCollection()
        : base([], m => m.id)
    {
        foreach (WKSMissionUnit mission in Svc.Data.GetExcelSheet<WKSMissionUnit>())
        {
            if (mission.Item.ToString() == "")
            {
                continue;
            }

            Add(new Mission(mission));
        }
    }
}
