using System;
using System.Collections.Generic;
using System.Text;
using Ferret.Configs;

namespace Ferret.Formatters;

public class TableFormatter<T> : IFormatter<List<T>>
{
    public string prefix { get; set; } = "";

    public string suffix { get; set; } = "";

    public int rowLength { get; set; } = 80;

    public Func<T, string> formatter { get; set; }

    public Func<T, bool> shouldInclude { get; set; }

    public TableFormatter(string prefix, string suffix, int rowLength, Func<T, string> formatter, Func<T, bool> shouldInclude)
    {
        this.prefix = prefix;
        this.suffix = suffix;
        this.rowLength = rowLength;
        this.formatter = formatter;
        this.shouldInclude = shouldInclude;
    }

    public string Format(ConfigOption<List<T>> option)
    {
        var str = new StringBuilder();
        str.AppendLine(prefix);

        int index = 0;
        while (index < option.value.Count)
        {
            var rowItems = new List<string>();
            int currentLength = 4; // Indentation

            while (index < option.value.Count)
            {
                var item = option.value[index];
                if (!shouldInclude(item))
                {
                    index++;
                    continue;
                }

                var formatted = formatter(item);
                var itemLength = formatted.Length + 2; // ", " after each item

                if (rowItems.Count > 0)
                    currentLength += itemLength;
                else
                    currentLength += formatted.Length;

                if (currentLength > rowLength)
                    break;

                rowItems.Add(formatted);
                index++;
            }

            str.AppendLine("    " + string.Join(", ", rowItems) + ",");
        }

        str.AppendLine(suffix);

        return str.ToString().TrimEnd();
    }
}
