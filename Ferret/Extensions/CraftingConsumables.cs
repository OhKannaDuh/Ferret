using Ferret.Collections.CosmicExploration;
using Ferret.Configs;
using Ferret.Formatters;
using Ferret.Models.Config;
using Ferret.Renderers;

namespace Ferret.Extensions;

public class CraftingConsumables : Extension
{
    public override string name => "Crafting Consumables";

    public override string file => "CraftingConsumables";

    public override string key => "crafting_consumables";

    protected override void InitialiseConfig(ConfigManager config)
    {
        config.Create(
            "food",
            (context) =>
                (ItemSelectionConfig)
                    new ItemSelectionConfig(context, new ItemSelection(new FoodCollection()))
                        .WithRenderer(new ItemSelectionRenderer("Food"))
                        .WithFormatter(new ItemSelectionFormatter($"{key}.food"))
                        .WithTooltip("")
        );

        config.Create(
            "food_threshold",
            (context) =>
                (IntConfig)
                    new IntConfig(context, 5)
                        .WithRenderer(new IntSliderRenderer("Food Threshold", 0, 30))
                        .WithFormatter(new IntFormatter($"{key}.food_threshold"))
                        .WithTooltip("")
        );

        config.Create(
            "medicine",
            (context) =>
                (ItemSelectionConfig)
                    new ItemSelectionConfig(context, new ItemSelection(new MedicineCollection()))
                        .WithRenderer(new ItemSelectionRenderer("Medicine"))
                        .WithFormatter(new ItemSelectionFormatter($"{key}.medicine"))
                        .WithTooltip("")
        );

        config.Create(
            "medicine_threshold",
            (context) =>
                (IntConfig)
                    new IntConfig(context, 5)
                        .WithRenderer(new IntSliderRenderer("Medicine Threshold", 0, 10))
                        .WithFormatter(new IntFormatter($"{key}.medicine_threshold"))
                        .WithTooltip("")
        );
    }
}
