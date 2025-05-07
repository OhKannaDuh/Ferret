namespace Ferret.Models.Presets;

public abstract class Preset : ScriptProfile
{
    public Preset()
    {
        InitialiseConfig(config);
        InitialiseExtensions(extensions);
    }
}
