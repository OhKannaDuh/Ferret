using System.Linq;
using ECommons;
using ECommons.DalamudServices;
using Ferret.Models.Data.CosmicExploration;
using Lumina.Excel.Sheets;
using Item = Ferret.Models.Data.Item;
using XIVItem = Lumina.Excel.Sheets.Item;

namespace Ferret.Collections.CosmicExploration;

public class FoodCollection : Collection<Item, uint>
{
    public FoodCollection()
        : base([], f => f.id)
    {
        var food = Svc
            .Data.GetExcelSheet<XIVItem>()
            .Where(item =>
            {
                if (item.ItemUICategory.RowId != 46)
                {
                    return false;
                }

                var consumable = GetItemConsumableProperties(item, false);
                if (consumable == null)
                {
                    return false;
                }

                return consumable.Value.Params.Any(p => p.BaseParam.RowId is 11 or 70 or 71);
            })
            .Reverse();

        foreach (XIVItem item in food)
        {
            Add(new Item(item.RowId, item.Name.ToString()));
        }
    }

    // Thanks Artisan
    private ItemFood? GetItemConsumableProperties(XIVItem item, bool hq)
    {
        if (!item.ItemAction.IsValid)
            return null;
        var action = item.ItemAction.Value;
        var actionParams = hq ? action.DataHQ : action.Data; // [0] = status, [1] = extra == ItemFood row, [2] = duration
        if (actionParams[0] is not 48 and not 49)
            return null; // not 'well fed' or 'medicated'
        return Svc.Data.GetExcelSheet<ItemFood>()?.GetRow(actionParams[1]);
    }
}
