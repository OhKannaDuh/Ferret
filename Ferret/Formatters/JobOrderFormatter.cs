using System;
using System.Collections.Generic;
using System.Text;
using Ferret.Configs;
using Ferret.Enums;
using Ferret.Models;
using Ferret.Models.Config;

namespace Ferret.Formatters;

public class JobOrderFormatter : IFormatter<JobOrder>
{
    public string prefix { get; set; } = "";

    public string suffix { get; set; } = "";

    public Func<Job, string> formatter { get; set; }

    public JobOrderFormatter(string prefix, string suffix, Func<Job, string> formatter)
    {
        this.prefix = prefix;
        this.suffix = suffix;
        this.formatter = formatter;
    }

    public string Format(ConfigOption<JobOrder> option)
    {
        var str = new StringBuilder();
        str.AppendLine(prefix);

        foreach (var job in option.value.order)
        {
            if (!option.value.jobs[job].enabled)
            {
                continue;
            }

            str.AppendLine($"    {formatter(job)},");
        }

        str.Append(suffix);

        return str.ToString();
    }
}
