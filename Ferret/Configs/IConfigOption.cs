namespace Ferret.Configs;

public interface IConfigOption
{
    string? tooltip { get; set; }

    bool hasChanged { get; }

    void Reset();

    string Format();

    void Render();

    void CopyValueFrom(IConfigOption other);
}
