using System.Collections.Generic;
using System.Linq;
using Ferret.Enums;

namespace Ferret.Models.Config;

public class JobOrder
{
    public Dictionary<Job, ToggleItem> jobs = new();

    public List<Job> order = new();

    public void Add(Job job)
    {
        jobs.Add(job, new ToggleItem(job.ToFriendlyString()));
        order.Add(job);
    }

    public JobOrder Clone()
    {
        return new JobOrder
        {
            jobs = jobs.ToDictionary(
                pair => pair.Key,
                pair => pair.Value.Clone() // assumes ToggleItem.Clone() exists
            ),
            order = new List<Job>(order),
        };
    }

    public static JobOrder Crafters()
    {
        JobOrder value = new();
        value.Add(Job.Carpenter);
        value.Add(Job.Blacksmith);
        value.Add(Job.Armorer);
        value.Add(Job.Goldsmith);
        value.Add(Job.Leatherworker);
        value.Add(Job.Weaver);
        value.Add(Job.Alchemist);
        value.Add(Job.Culinarian);

        return value;
    }
}
