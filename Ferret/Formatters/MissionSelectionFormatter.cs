using System.Collections.Generic;
using System.Linq;
using System.Text;
using Ferret.Configs;
using Ferret.Models.Config;

namespace Ferret.Formatters;

public class MissionSelectionFormatter : IFormatter<MissionSelection>
{
    public string prefix { get; set; } = "";

    public string suffix { get; set; } = "";

    public int rowLength { get; set; } = 80;

    public MissionSelectionFormatter(string prefix, string suffix, int rowLength)
    {
        this.prefix = prefix;
        this.suffix = suffix;
        this.rowLength = rowLength;
    }

    public string Format(ConfigOption<MissionSelection> option)
    {
        var str = new StringBuilder();
        str.AppendLine(prefix);

        var selection = option.value;

        // Build the ordered list of selected missions
        var orderedSelected = selection
            .selectedOrder.Where(i => i >= 0 && i < selection.missions.Count)
            .Select(i => selection.missions[i])
            .Where(m => m.selected)
            .ToList();

        int index = 0;
        while (index < orderedSelected.Count)
        {
            var rowItems = new List<string>();
            int currentLength = 4; // Indentation

            for (int i = index; i < orderedSelected.Count; i++)
            {
                var data = orderedSelected[i];
                var formatted = data.mission.id.ToString();
                var itemLength = formatted.Length + 2;

                if (currentLength + itemLength > rowLength)
                    break;

                rowItems.Add(formatted);
                currentLength += itemLength;
            }

            if (rowItems.Count > 0)
                str.AppendLine("    " + string.Join(", ", rowItems) + ",");

            index += rowItems.Count > 0 ? rowItems.Count : 1;
        }

        str.AppendLine(suffix);
        return str.ToString().Trim();
    }
}
