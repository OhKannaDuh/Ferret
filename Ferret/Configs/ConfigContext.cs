using System.Collections.Generic;
using System.Linq;

namespace Ferret.Configs;

public class ConfigContext
{
    public Dictionary<string, IConfigOption> options { get; } = new();

    public T Get<T>(string key)
        where T : IConfigOption => (T)options[key];

    public void Add(string key, IConfigOption option)
    {
        options[key] = option;
    }

    public bool TryGet<T>(string key, out T? option)
        where T : class, IConfigOption
    {
        if (options.TryGetValue(key, out var value) && value is T t)
        {
            option = t;
            return true;
        }
        option = null;
        return false;
    }

    public bool HasChanged() => options.Values.Any(option => option.hasChanged);
}
