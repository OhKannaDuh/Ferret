using System.Text;
using Ferret.Configs;
using Ferret.Enums;
using Ferret.Models.Config;

namespace Ferret.Formatters;

public class MissionAssignmentFormatter : IFormatter<MissionAssignment>
{
    private readonly string prefix = "";

    private readonly string suffix = "";

    public MissionAssignmentFormatter(string prefix, string suffix)
    {
        this.prefix = prefix;
        this.suffix = suffix;
    }

    public string Format(ConfigOption<MissionAssignment> option)
    {
        // Initialize an empty list to hold the formatted lines
        var str = new StringBuilder();
        str.AppendLine(prefix);

        // Loop through each mission in the assignment and check if its result is different from the global result
        foreach (var mission in option.value.missions)
        {
            if (mission.result != option.value.result.value)
            {
                str.AppendLine($"    [{mission.mission.id}] = {mission.result.ToLuaEnum()},");
            }
        }

        return str.AppendLine(suffix).ToString().Trim();
    }
}
