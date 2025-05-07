namespace Ferret.Enums;

public enum MissionResult
{
    Gold,
    Silver,
    Bronze,
}

public static class MissionResultExtensions
{
    public static string ToFriendlyString(this MissionResult self)
    {
        return self switch
        {
            MissionResult.Gold => "Gold",
            MissionResult.Silver => "Silver",
            MissionResult.Bronze => "Bronze",
            _ => "Gold",
        };
    }

    public static string ToLuaEnum(this MissionResult self)
    {
        return self switch
        {
            MissionResult.Gold => "MissionResult.Gold",
            MissionResult.Silver => "MissionResult.Silver",
            MissionResult.Bronze => "MissionResult.Bronze",
            _ => "MissionResult.Gold",
        };
    }
}
