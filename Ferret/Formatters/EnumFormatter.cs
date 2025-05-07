using System;
using Ferret.Configs;

namespace Ferret.Formatters;

public class EnumFormatter<T> : IFormatter<T>
    where T : Enum
{
    private readonly string key = "";

    private readonly Func<T, string> formatter;

    public EnumFormatter(string key, Func<T, string> formatter)
    {
        this.key = key;
        this.formatter = formatter;
    }

    public string Format(ConfigOption<T> option)
    {
        return $"{key} = {formatter(option.value)}";
    }
}
