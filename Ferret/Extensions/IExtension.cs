namespace Ferret.Extensions;

public interface IExtension
{
    public string name { get; }

    public string file { get; }

    public string key { get; }

    public bool enabled { get; set; }

    bool hasChanged { get; }

    void Render();

    string Format();

    void Reset();
}
