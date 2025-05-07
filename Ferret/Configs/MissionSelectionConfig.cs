using Ferret.Models.Config;

namespace Ferret.Configs;

public class MissionSelectionConfig : ConfigOption<MissionSelection>
{
    public override bool hasChanged => value.selectedOrder.Count > 0;

    public MissionSelectionConfig(ConfigContext context, MissionSelection value)
        : base(context, value.Clone())
    {
        this.value = value;
    }
}
