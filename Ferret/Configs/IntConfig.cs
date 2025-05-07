namespace Ferret.Configs;

public class IntConfig : ConfigOption<int>
{
    public IntConfig(ConfigContext context, int value)
        : base(context, value) { }
}
