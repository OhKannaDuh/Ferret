using Ferret.Models;

namespace Ferret.Generators;

public class StartGenerator : ILuaSectionGenerator
{
    public LuaScript Generate(LuaScript script) => script.NewLine().AddLine("ferret:start()");

    public void Render() { }

    public void Reset() { }
}
