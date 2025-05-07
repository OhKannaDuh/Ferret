using System.Collections.Generic;
using Ferret.Enums;
using Ferret.Models;
using Ferret.Models.Config;

namespace Ferret.Configs;

public class JobOrderConfig : ConfigOption<JobOrder>
{
    public JobOrderConfig(ConfigContext context, JobOrder value)
        : base(context, value.Clone())
    {
        this.value = value;
    }

    public override bool hasChanged => !JobsEqual(original.jobs, value.jobs) || !OrderEqual(original.order, value.order);

    private bool JobsEqual(Dictionary<Job, ToggleItem> a, Dictionary<Job, ToggleItem> b)
    {
        if (a.Count != b.Count)
            return false;

        foreach (var pair in a)
        {
            if (!b.TryGetValue(pair.Key, out var bItem))
                return false;

            if (pair.Value.enabled != bItem.enabled)
                return false;
        }

        return true;
    }

    private bool OrderEqual(List<Job> a, List<Job> b)
    {
        if (a.Count != b.Count)
            return false;
        for (int i = 0; i < a.Count; i++)
        {
            if (!a[i].Equals(b[i]))
                return false;
        }
        return true;
    }
}
