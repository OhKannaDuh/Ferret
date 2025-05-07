using System;
using Ferret.Formatters;
using Ferret.Renderers;

namespace Ferret.Configs;

public class ConfigOption<T> : IConfigOption
    where T : notnull
{
    public readonly ConfigContext context;

    public readonly T original;

    private T _value;

    public virtual T value
    {
        get => _value;
        set
        {
            if (!Equals(_value, value))
            {
                _value = value;
                OnChange?.Invoke(this, _value);
            }
        }
    }
    public event Action<ConfigOption<T>, T>? OnChange;

    public virtual bool hasChanged => !Equals(value, original);

    public IRenderer<T>? renderer;

    public IFormatter<T>? formatter;

    public string? tooltip { get; set; } = null;

    public ConfigOption(ConfigContext context, T original)
    {
        this.context = context;
        this.original = original;
        _value = original;
        value = original;
    }

    public ConfigOption<T> WithRenderer(IRenderer<T> renderer)
    {
        this.renderer = renderer;
        return this;
    }

    public ConfigOption<T> WithFormatter(IFormatter<T> formatter)
    {
        this.formatter = formatter;
        return this;
    }

    public ConfigOption<T> WithTooltip(string tooltip)
    {
        this.tooltip = tooltip;
        return this;
    }

    public virtual void Reset() => value = original;

    public string Format() => formatter!.Format(this);

    public void Render() => renderer!.Render(this);

    public virtual void CopyValueFrom(IConfigOption other)
    {
        if (other is ConfigOption<T> typed)
        {
            value = typed.value;
        }
    }

    public void TriggerChange()
    {
        OnChange?.Invoke(this, this.value);
    }
}
