using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace Ferret.Collections;

public class Collection<T, K> : IEnumerable<T>
    where T : notnull
    where K : notnull
{
    protected Dictionary<K, T> items;

    protected Func<T, K> keySelector;

    public Collection(IEnumerable<T> items, Func<T, K> keySelector)
    {
        this.keySelector = keySelector;
        this.items = items.ToDictionary(keySelector);
    }

    public virtual IEnumerable<T> All => items.Values;

    public bool Contains(K key) => items.ContainsKey(key);

    public void Add(T item)
    {
        var key = keySelector(item);
        // if (!items.ContainsKey(key))
        // {
        items.Add(key, item);
        // }
        // else
        // {
        //     throw new ArgumentException("An item with the same key already exists: " + key);
        // }
    }

    // public T? Get(K id)
    // {
    // }

    public bool TryGet(K id, out T? value)
    {
        return items.TryGetValue(id, out value);
    }

    public bool Remove(K key)
    {
        return items.Remove(key);
    }

    public IEnumerator<T> GetEnumerator() => All.GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
}
