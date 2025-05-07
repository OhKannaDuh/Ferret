namespace Ferret.Models;

public class ToggleItem
{
    public string name { get; set; }
    public bool enabled { get; set; }

    public ToggleItem(string name, bool enabled = true)
    {
        this.name = name;
        this.enabled = enabled;
    }

    public ToggleItem Clone()
    {
        return new ToggleItem(name, enabled);
    }
}
