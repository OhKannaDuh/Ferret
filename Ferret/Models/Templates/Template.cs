using System.Collections.Generic;
using ECommons.DalamudServices;
using Ferret.Configs;
using Ferret.Extensions;
using Ferret.Models.Presets;

namespace Ferret.Models.Templates;

public abstract class Template : ScriptProfile
{
    public virtual List<Preset> presets => [];

    public Template()
    {
        InitialiseConfig(config);
        InitialiseExtensions(extensions);
    }
}
