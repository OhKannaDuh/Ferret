namespace Ferret.Models.Data;

public class Item
{
    public readonly uint id;

    public readonly string name = "";

    public Item(uint id, string name)
    {
        this.id = id;
        this.name = name;
    }
}
