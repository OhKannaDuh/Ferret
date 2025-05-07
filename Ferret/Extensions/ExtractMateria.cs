using Ferret.Configs;

namespace Ferret.Extensions;

public class ExtractMateria : Extension
{
    public override string name => "Extract Materia";

    public override string file => "ExtractMateria";

    public override string key => "extract_materia";

    protected override void InitialiseConfig(ConfigManager config) { }
}
