using ECommons.ExcelServices;
using Ferret.Enums;
using Ferret.UI;
using Lumina.Excel.Sheets;

namespace Ferret.Models.Data;

public class Item
{
    public readonly uint id;

    public readonly string name = "";

    public Item(uint id, string name)
    {
        this.id = id;
        this.name = name;
        // name = datum.Item.ToString().Replace(" ", "");
        // id = datum.RowId;
        // primaryJobId = datum.Unknown1 - 1;
        // secondatryJobId = datum.Unknown2;
    }
}
