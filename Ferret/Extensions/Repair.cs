using Ferret.Configs;
using Ferret.Formatters;
using Ferret.Renderers;

namespace Ferret.Extensions;

public class Repair : Extension
{
    public override string name => "Repair";

    public override string file => "Repair";

    public override string key => "repair";

    protected override void InitialiseConfig(ConfigManager config)
    {
        config.Create(
            "threshold",
            (context) =>
                (IntConfig)
                    new IntConfig(context, 50)
                        .WithRenderer(new IntSliderRenderer("Threshold", 1, 99))
                        .WithFormatter(new IntFormatter($"{key}.threshold"))
                        .WithTooltip("")
        );
    }
}
