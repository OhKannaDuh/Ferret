using Ferret.Configs;
using Ferret.Extensions;

namespace Ferret.Models.Templates;

public class BlankTemplate : Template
{
    public override string name => "None";

    public override string path => "";

    protected override void InitialiseConfig(ConfigManager config) { }

    protected override void InitialiseExtensions(ExtensionManager extensions) { }
}
