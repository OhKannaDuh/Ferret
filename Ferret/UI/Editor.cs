using ImGuiColorTextEditNet;
using ImGuiNET;

namespace Ferret.UI;

public class Editor
{
    private readonly TextEditor editor;

    public bool isReadyOnly
    {
        get => editor.Options.IsReadOnly;
        set => editor.Options.IsReadOnly = value;
    }

    public string text
    {
        get => editor.AllText;
        set => editor.AllText = value;
    }

    public Editor()
    {
        editor = new TextEditor { SyntaxHighlighter = new LuaHighlighter() };
    }

    public void SetSyntaxHighlighter(ISyntaxHighlighter highlighter)
    {
        editor.SyntaxHighlighter = highlighter;
    }

    public void SetPalette(uint[] palette)
    {
        editor.Renderer.Palette = palette;
    }

    public void Render()
    {
        ImGui.BeginChild("Editor_FerretScript", ImGui.GetContentRegionAvail(), true);
        editor.Render("Ferret Script");
        ImGui.EndChild();
    }
}
