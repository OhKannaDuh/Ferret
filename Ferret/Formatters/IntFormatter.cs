using Ferret.Configs;

namespace Ferret.Formatters;

public class IntFormatter : IFormatter<int>
{
    private readonly string key = "";

    public IntFormatter(string key)
    {
        this.key = key;
    }

    public string Format(ConfigOption<int> option)
    {
        return $"{key} = {option.value}";
    }
}
