using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

namespace Ferret.Collections;

public class AutoCollection<T, K> : Collection<T, K>
    where T : class
    where K : notnull
{
    public AutoCollection(Func<T, K> keySelector)
        : base(Discover(), keySelector) { }

    private static IEnumerable<T> Discover()
    {
        return AppDomain
            .CurrentDomain.GetAssemblies()
            .SelectMany(asm => SafeGetTypes(asm))
            .Where(t => typeof(T).IsAssignableFrom(t) && !t.IsAbstract && t.GetConstructor(Type.EmptyTypes) != null)
            .Select(t => Activator.CreateInstance(t) as T)
            .Where(instance => instance != null)!;
    }

    private static IEnumerable<Type> SafeGetTypes(Assembly asm)
    {
        try
        {
            return asm.GetTypes();
        }
        catch (ReflectionTypeLoadException e)
        {
            return e.Types.Where(t => t != null)!;
        }
    }
}
