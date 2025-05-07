using Ferret.Configs;

namespace Ferret.Formatters;

public class StringFormatter : IFormatter<string>
{
    private readonly string key = "";

    public StringFormatter(string key)
    {
        this.key = key;
    }

    public string Format(ConfigOption<string> option)
    {
        return $"{key} = \"{option.value}\"";
    }
}
