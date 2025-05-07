namespace Ferret.Configs;

public class BoolConfig : ConfigOption<bool>
{
    public BoolConfig(ConfigContext context, bool value)
        : base(context, value) { }
}
