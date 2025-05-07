namespace Ferret.Enums;

public enum Language
{
    DE,
    EN,
    FR,
    JP,
}

public static class LanguageExtensions
{
    public static string ToFriendlyString(this Language self)
    {
        return self switch
        {
            Language.DE => "de",
            Language.EN => "en",
            Language.FR => "fr",
            Language.JP => "jp",
            _ => "en",
        };
    }
}
