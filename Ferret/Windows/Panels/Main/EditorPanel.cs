using Ferret.Generators;
using Ferret.UI;
using ImGuiColorTextEditNet;

namespace Ferret.Windows.Panels.Main;

public class EditorPanel
{
    private Editor editor = new();

    public string text
    {
        get => editor.text;
        set => editor.text = value;
    }

    public EditorPanel()
    {
        editor.isReadyOnly = true;
        editor.SetPalette(Palettes.DarkMaterial);
    }

    public void Render()
    {
        editor.Render();
    }
}
