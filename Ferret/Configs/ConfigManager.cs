using System;
using System.Collections.Generic;

namespace Ferret.Configs;

public class ConfigManager
{
    public ConfigContext context { get; } = new();

    public T Create<T>(string key, Func<ConfigContext, T> factory)
        where T : IConfigOption
    {
        var option = factory(context);
        context.Add(key, option);
        return option;
    }

    public bool HasChanged() => context.HasChanged();
}
