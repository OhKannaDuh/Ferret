using Ferret.Configs;
using Ferret.Models.Config;

namespace Ferret.Formatters;

public class ItemSelectionFormatter : IFormatter<ItemSelection>
{
    private readonly string key = "";

    public ItemSelectionFormatter(string key)
    {
        this.key = key;
    }

    public string Format(ConfigOption<ItemSelection> option)
    {
        return $"{key} = \"{option.value}\"";
    }
}
