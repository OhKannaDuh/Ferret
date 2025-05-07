using System;
using System.Collections.Generic;
using System.Linq;
using ECommons;
using Ferret.Collections.CosmicExploration;
using Ferret.Enums;

namespace Ferret.Models.Config;

public class MissionSelection
{
    public List<SelectedMission> missions = [];

    public List<int> selectedOrder = [];

    public bool reorderable = false;

    public string search = "";

    public Job selectedFilter = Job.Any;

    public readonly List<Job> filterOptions = new()
    {
        Job.Any,
        Job.Carpenter,
        Job.Blacksmith,
        Job.Armorer,
        Job.Goldsmith,
        Job.Leatherworker,
        Job.Weaver,
        Job.Alchemist,
        Job.Culinarian,
    };

    public MissionSelection()
    {
        foreach (var mission in new MissionCollection())
        {
            this.missions.Add(new SelectedMission(mission));
        }
    }

    public MissionSelection Clone()
    {
        return new MissionSelection
        {
            missions = this.missions.Select(m => new SelectedMission(m.mission) { selected = m.selected }).ToList(),

            selectedOrder = new List<int>(this.selectedOrder),
            reorderable = this.reorderable,
            search = this.search,
            selectedFilter = this.selectedFilter,
        };
    }

    public MissionSelection Reorderable()
    {
        this.reorderable = true;
        return this;
    }

    public IEnumerable<SelectedMission> GetSelected() => missions.Where(value => value.selected);

    public IEnumerable<SelectedMission> GetUnselected() => missions.Where(value => !value.selected);

    public IEnumerable<SelectedMission> GetFiltered()
    {
        IEnumerable<SelectedMission> filtered = GetUnselected();
        if (search != "")
        {
            filtered = filtered.Where(value => value.mission.GetLabel().Contains(search, StringComparison.OrdinalIgnoreCase));
        }

        if (selectedFilter != Job.Any)
        {
            filtered = filtered.Where(value => value.mission.GetJob() == selectedFilter);
        }

        return filtered;
    }

    public void SwapItemOrder(int oldIndex, int newIndex)
    {
        var temp = selectedOrder[oldIndex];
        selectedOrder[oldIndex] = selectedOrder[newIndex];
        selectedOrder[newIndex] = temp;
    }
}
