using Ferret.Configs;

namespace Ferret.Formatters;

public interface IFormatter<T>
    where T : notnull
{
    string Format(ConfigOption<T> option);
}
