using Ferret.Enums;

namespace Ferret.Configs;

public class MissionOrderConfig : ConfigOption<MissionOrder>
{
    public MissionOrderConfig(ConfigContext context, MissionOrder value)
        : base(context, value) { }
}
