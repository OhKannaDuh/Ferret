import { Mission } from "./Mission";
import { Model } from "./Model";
import { Recipe } from "./Recipe";
import { BelongsToOne } from "./Relationships/BelongsToOne";
import { HasMany } from "./Relationships/HasMany";

export class MissionRecipeSet extends Model {
    mission_id: number;
    recipe_ids: number[];

    constructor(data: any) {
        super();

        this.mission_id = Number(data.mission_id);
        this.recipe_ids = [
            Number(data.recipe_id_1),
            Number(data.recipe_id_2),
            Number(data.recipe_id_3),
            Number(data.recipe_id_4),
            Number(data.recipe_id_5),
        ].filter((id) => id !== 0);
    }
    public recipes(): HasMany<Recipe> {
        const repo = Model.getRepository(Recipe);
        const allRecipes = this.recipe_ids
            .map((id) => repo.find((r) => r.id === id))
            .filter((r): r is Recipe => !!r);

        const outputToRecipe = new Map<number, Recipe>();
        for (const recipe of allRecipes) {
            if (recipe.output_item > 0) {
                outputToRecipe.set(recipe.output_item, recipe);
            }
        }

        const dependencies = new Map<Recipe, Set<Recipe>>();
        const inDegree = new Map<Recipe, number>();

        for (const recipe of allRecipes) {
            dependencies.set(recipe, new Set());
            inDegree.set(recipe, 0);
        }

        for (const recipe of allRecipes) {
            const inputs = recipe.get_input_item_ids();
            for (const input of inputs) {
                const producer = outputToRecipe.get(input);
                if (producer && producer !== recipe) {
                    dependencies.get(producer)!.add(recipe);
                    inDegree.set(recipe, (inDegree.get(recipe) ?? 0) + 1);
                }
            }
        }

        const sorted: Recipe[] = [];
        const queue: Recipe[] = [];

        for (const [recipe, degree] of inDegree.entries()) {
            if (degree === 0) queue.push(recipe);
        }

        while (queue.length > 0) {
            const current = queue.shift()!;
            sorted.push(current);

            for (const neighbor of dependencies.get(current)!) {
                inDegree.set(neighbor, inDegree.get(neighbor)! - 1);
                if (inDegree.get(neighbor) === 0) {
                    queue.push(neighbor);
                }
            }
        }

        return new HasMany(sorted);
    }

    public mission(): BelongsToOne<Mission> {
        const repo = Model.getRepository(Mission);
        const mission = repo.find((m) => m.id === this.mission_id);
        return new BelongsToOne(mission);
    }

    public get_crafting_order() {
        const recipes = this.recipes().get();

        let order = recipes.map((recipe) => recipe.id);

        // Create a map of outputs to recipes
        let output_map = new Map<number, Recipe>();
        recipes.forEach((recipe) => output_map.set(recipe.output_item, recipe));

        const base_input = 48233;

        // Create an array to track which recipes have already been ordered
        let ordered_recipes = new Set<number>();

        // Loop through the recipes and check their inputs
        for (const recipe of recipes) {
            // If the recipe is already ordered, skip it
            if (ordered_recipes.has(recipe.id)) continue;

            // Add the recipe to the ordered set
            ordered_recipes.add(recipe.id);

            recipe.inputs.forEach((input) => {
                if (output_map.has(input.item)) {
                    const producing_recipe = output_map.get(input.item)!;

                    // Only reorder if producing recipe is not already ordered before
                    if (!ordered_recipes.has(producing_recipe.id)) {
                        // Ensure the producing recipe comes before the current recipe
                        const index_of_producing = order.indexOf(
                            producing_recipe.id
                        );
                        const index_of_current = order.indexOf(recipe.id);

                        if (index_of_current > index_of_producing) {
                            order.splice(index_of_current, 1); // Remove the current recipe
                            order.splice(index_of_producing, 0, recipe.id); // Insert it before the producing recipe
                        }
                    }
                }
            });
        }

        return order;
    }

    public get_crafting_amount(order: number[]): Map<number, number> {
        const amount = new Map<number, number>();
        const output_map = new Map<number, Recipe>();
        const recipe_map = new Map<number, Recipe>();

        const recipes = this.recipes().get();

        for (const recipe of recipes) {
            output_map.set(recipe.output_item, recipe);
            recipe_map.set(recipe.id, recipe);
        }

        // Start by assuming we need to craft each end-product once
        for (const recipe_id of order) {
            amount.set(recipe_id, 0);
        }

        // We process from back to front so dependencies are handled first
        for (let i = order.length - 1; i >= 0; i--) {
            const recipe_id = order[i];
            const recipe = recipe_map.get(recipe_id);
            if (!recipe) continue;

            // If no one needs this recipe's output, we assume it's needed once
            const current_amount = amount.get(recipe_id) ?? 0;
            const craft_count = current_amount === 0 ? 1 : current_amount;

            // For each input of this recipe
            for (const input of recipe.inputs) {
                const input_recipe = output_map.get(input.item);
                if (!input_recipe) continue;

                const input_recipe_id = input_recipe.id;
                const existing = amount.get(input_recipe_id) ?? 0;
                // Add to the input recipe's required craft count
                amount.set(
                    input_recipe_id,
                    existing + input.amount * craft_count
                );
            }

            // Save final craft count for current recipe
            amount.set(recipe_id, craft_count);
        }

        return amount;
    }
}
