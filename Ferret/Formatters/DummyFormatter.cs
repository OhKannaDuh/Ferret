using Ferret.Configs;

namespace Ferret.Formatters;

public class DummyFormatter<T> : IFormatter<T>
    where T : notnull
{
    public string Format(ConfigOption<T> option)
    {
        return "--- Dummy Formatter in use ---";
    }
}
