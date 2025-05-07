using Ferret.Configs;

namespace Ferret.Formatters;

public class BoolFormatter : IFormatter<bool>
{
    private readonly string key = "";

    public BoolFormatter(string key)
    {
        this.key = key;
    }

    public string Format(ConfigOption<bool> option)
    {
        return $"{key} = {(option.value ? "true" : "false")}";
    }
}
