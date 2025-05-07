using Ferret.Enums;

namespace Ferret.Configs;

public class MissionResultConfig : ConfigOption<MissionResult>
{
    public MissionResultConfig(ConfigContext context, MissionResult value)
        : base(context, value) { }
}
