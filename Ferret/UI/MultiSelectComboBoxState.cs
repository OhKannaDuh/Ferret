using System;
using System.Collections.Generic;

namespace Ferret.UI;

public struct MultiSelectComboBoxState<T, F>
    where T : IMultiSelectable
    where F : Enum?
{
    public List<T> items;

    public List<int> selectedItemOrder = [];

    public string term = "";

    public List<F> filterOptions;

    public F selectedFilter;

    public Func<F, string> getFilterOptionName = (t) => t!.ToString();

    public Func<T, F, bool> filterBy = (t, f) => false;

    public bool reorderable { get; private set; } = false;

    public MultiSelectComboBoxState(ref List<T> items, List<F> filterOptions, F selectedFilter, Func<F, string> getFilterOptionName, Func<T, F, bool> filterBy)
    {
        this.items = items;
        this.filterOptions = filterOptions;
        this.selectedFilter = selectedFilter;
        this.getFilterOptionName = getFilterOptionName;
        this.filterBy = filterBy;
    }

    public void Reorderable() => reorderable = true;

    public void SwapItemOrder(int oldIndex, int newIndex)
    {
        var temp = selectedItemOrder[oldIndex];
        selectedItemOrder[oldIndex] = selectedItemOrder[newIndex];
        selectedItemOrder[newIndex] = temp;
    }
}
