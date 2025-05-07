using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Ferret.Configs;

namespace Ferret.Formatters;

public class DictionaryTableFormatter<K, V> : IFormatter<Dictionary<K, V>>
    where K : notnull
{
    public string prefix { get; set; } = "";

    public string suffix { get; set; } = "";

    public int rowLength { get; set; } = 80;

    public Func<K, string> keyFormatter { get; set; }

    public Func<V, string> valueFormatter { get; set; }

    public Func<KeyValuePair<K, V>, bool> shouldInclude { get; set; }

    public DictionaryTableFormatter(
        string prefix,
        string suffix,
        int rowLength,
        Func<K, string> keyFormatter,
        Func<V, string> valueFormatter,
        Func<KeyValuePair<K, V>, bool> shouldInclude
    )
    {
        this.prefix = prefix;
        this.suffix = suffix;
        this.rowLength = rowLength;
        this.keyFormatter = keyFormatter;
        this.valueFormatter = valueFormatter;
        this.shouldInclude = shouldInclude;
    }

    public string Format(ConfigOption<Dictionary<K, V>> option)
    {
        var str = new StringBuilder();
        str.AppendLine(prefix);

        int index = 0;
        var dictionary = option.value;

        while (index < dictionary.Count)
        {
            var rowItems = new List<string>();
            int currentLength = 4; // Indentation

            // Process each pair starting from 'index'
            for (int i = index; i < dictionary.Count; i++)
            {
                var pair = dictionary.ElementAt(i); // Get the key-value pair by index
                if (!shouldInclude(pair))
                {
                    continue;
                }

                var keyFormatted = keyFormatter(pair.Key);
                var valueFormatted = valueFormatter(pair.Value);
                var formattedPair = $"    {keyFormatted} = {valueFormatted}";
                var itemLength = formattedPair.Length + 2; // ", " after each item

                // Check if adding this item will exceed the row length
                if (currentLength + itemLength > rowLength)
                    break;

                rowItems.Add(formattedPair);
                currentLength += itemLength;
            }

            // Append the row to the result
            str.AppendLine("    " + string.Join(", ", rowItems) + ",");

            // Move the index forward by the number of items added to the row
            index += rowItems.Count;
        }

        str.AppendLine(suffix);

        return str.ToString().TrimEnd();
    }
}
