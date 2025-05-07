using Ferret.Collections;
using Ferret.Models.Data;

namespace Ferret.Models.Config;

public class ItemSelection
{
    public Collection<Item, uint> items;

    public string selected = "";

    public bool hq = true;

    public ItemSelection(Collection<Item, uint> items)
    {
        this.items = items;
    }

    public override string ToString()
    {
        return $"{selected}{(hq ? " <HQ>" : "")}";
    }
}
