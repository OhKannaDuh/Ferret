using ECommons.DalamudServices;
using Lumina.Excel.Sheets;

namespace Ferret.Collections.CosmicExploration;

public class ItemCollection : Collection<Item, uint>
{
    public ItemCollection()
        : base([], f => f.RowId)
    {
        foreach (Item item in Svc.Data.GetExcelSheet<Item>())
        {
            Add(item);
        }
    }
}
