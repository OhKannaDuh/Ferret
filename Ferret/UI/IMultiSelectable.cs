namespace Ferret.UI;

public interface IMultiSelectable
{
    string GetLabel();

    bool IsSelected();

    void SetIsSelected(bool isSelected);
}
