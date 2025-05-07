namespace Ferret.Configs;

public class StringConfig : ConfigOption<string>
{
    public StringConfig(ConfigContext context, string value)
        : base(context, value) { }

    public static StringConfig Create(ConfigContext context, string value) => new StringConfig(context, value);
}
