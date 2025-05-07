using Ferret.Models;

namespace Ferret.Generators;

public interface ILuaSectionGenerator
{
    LuaScript Generate(LuaScript script);

    void Render();

    void Reset();
}
