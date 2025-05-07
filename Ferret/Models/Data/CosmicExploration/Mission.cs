using ECommons.ExcelServices;
using Ferret.Enums;
using Ferret.UI;
using Lumina.Excel.Sheets;

namespace Ferret.Models.Data.CosmicExploration;

public class Mission
{
    public readonly string name = "";

    public readonly uint id;

    public readonly int primaryJobId = 0;

    public readonly int secondatryJobId = 0;

    public Mission(WKSMissionUnit datum)
    {
        name = datum.Item.ToString().Replace(" ", "");
        id = datum.RowId;
        primaryJobId = datum.Unknown1 - 1;
        secondatryJobId = datum.Unknown2;
    }

    public Enums.Job GetJob() => (Enums.Job)primaryJobId;

    public string GetLabel() => id.ToString() + " - " + name + " - " + GetJob().ToShortString();
}
