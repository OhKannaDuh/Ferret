using System;
using Dalamud.Configuration;
using ECommons.DalamudServices;

namespace Ferret;

[Serializable]
public class Config : IPluginConfiguration
{
    public int Version { get; set; } = 0;

    public void Save()
    {
        Svc.PluginInterface.SavePluginConfig(this);
    }
}
