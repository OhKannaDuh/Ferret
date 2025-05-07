using System.Text;
using System.Text.RegularExpressions;

namespace Ferret.Models;

public class LuaScript
{
    private string script = "";

    public LuaScript Clear()
    {
        script = "";
        return this;
    }

    public LuaScript NewLine()
    {
        script += "\n";
        return this;
    }

    public LuaScript AddLine(string line)
    {
        if (script != "")
        {
            NewLine();
        }

        script += line;
        return this;
    }

    public LuaScript AddSameLine(string line)
    {
        script += line;
        return this;
    }

    private string Format()
    {
        var lines = script.Split(new[] { "\r\n", "\n" }, System.StringSplitOptions.None);
        var sb = new StringBuilder();

        for (int i = 0; i < lines.Length; i++)
        {
            string line = lines[i].TrimEnd();
            string trimmed = line.Trim();

            if (trimmed.StartsWith("---"))
            {
                sb.AppendLine("");
            }

            sb.AppendLine(line);

            bool shouldAddBlankLine =
                // local var declarations
                Regex.IsMatch(trimmed, @"^local\s+\w+\s*=")
                ||
                // closing table brace
                Regex.IsMatch(trimmed, @"^\}[\s,]*$")
                ||
                // top-level assignment (excluding 'local')
                (Regex.IsMatch(trimmed, @"^[\w\.]+\s*=\s*.+$") && !trimmed.StartsWith("local") && !trimmed.EndsWith("{") && !trimmed.EndsWith("{,"));

            // Avoid double-blank lines and skip if the next line is already blank
            if (shouldAddBlankLine && i + 1 < lines.Length && !string.IsNullOrWhiteSpace(lines[i + 1]))
            {
                sb.AppendLine();
            }
        }

        return sb.ToString().Trim().Replace("\r\n\r\n", "\n").Replace("\n\n", "\n");
    }

    public override string ToString()
    {
        return Regex.Replace(script, @"(\r?\n){2,}", "\n\n").Trim() + "\n";
    }
}
