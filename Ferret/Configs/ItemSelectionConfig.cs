using Ferret.Models.Config;

namespace Ferret.Configs;

public class ItemSelectionConfig : ConfigOption<ItemSelection>
{
    public override bool hasChanged => value.selected != "";

    public ItemSelectionConfig(ConfigContext context, ItemSelection value)
        : base(context, value) { }
}
