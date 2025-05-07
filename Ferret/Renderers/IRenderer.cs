using Ferret.Configs;

namespace Ferret.Renderers;

public interface IRenderer<T>
    where T : notnull
{
    void Render(ConfigOption<T> option);
}
