using System.Collections.Generic;

namespace Ferret.Enums;

public enum Job
{
    Unknown = -2,
    Any = -1,
    Carpenter = 8,
    Blacksmith = 9,
    Armorer = 10,
    Goldsmith = 11,
    Leatherworker = 12,
    Weaver = 13,
    Alchemist = 14,
    Culinarian = 15,
}

public static class JobExtensions
{
    public static string ToFriendlyString(this Job self)
    {
        return self switch
        {
            Job.Unknown => "None",
            Job.Any => "Any",
            Job.Carpenter => "Carpenter",
            Job.Blacksmith => "Blacksmith",
            Job.Armorer => "Armorer",
            Job.Goldsmith => "Goldsmith",
            Job.Leatherworker => "Leatherworker",
            Job.Weaver => "Weaver",
            Job.Alchemist => "Alchemist",
            Job.Culinarian => "Culinarian",
            _ => "None",
        };
    }

    public static string ToShortString(this Job self)
    {
        return self switch
        {
            Job.Unknown => "None",
            Job.Any => "Any",
            Job.Carpenter => "CRP",
            Job.Blacksmith => "BSM",
            Job.Armorer => "ARM",
            Job.Goldsmith => "GSM",
            Job.Leatherworker => "LTW",
            Job.Weaver => "WVR",
            Job.Alchemist => "ALC",
            Job.Culinarian => "CUL",
            _ => "None",
        };
    }

    public static string ToLuaEnum(this Job self)
    {
        return self switch
        {
            Job.Unknown => "Jobs.Unknown",
            Job.Any => "Jobs.Unknown",
            Job.Carpenter => "Jobs.Carpenter",
            Job.Blacksmith => "Jobs.Blacksmith",
            Job.Armorer => "Jobs.Armorer",
            Job.Goldsmith => "Jobs.Goldsmith",
            Job.Leatherworker => "Jobs.Leatherworker",
            Job.Weaver => "Jobs.Weaver",
            Job.Alchemist => "Jobs.Alchemist",
            Job.Culinarian => "Jobs.Culinarian",
            _ => "Jobs.Unknown",
        };
    }
}
