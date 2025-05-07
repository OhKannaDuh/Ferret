namespace Ferret.Enums;

public enum MissionOrder
{
    TopPriority,
    Random,
}

public static class MissionOrderExtensions
{
    public static string ToFriendlyString(this MissionOrder self)
    {
        return self switch
        {
            MissionOrder.TopPriority => "Top Priority",
            MissionOrder.Random => "Random",
            _ => "Top Priority",
        };
    }

    public static string ToLuaEnum(this MissionOrder self)
    {
        return self switch
        {
            MissionOrder.TopPriority => "MissionOrder.TopPriority",
            MissionOrder.Random => "MissionOrder.Random",
            _ => "MissionOrder.TopPriority",
        };
    }
}
