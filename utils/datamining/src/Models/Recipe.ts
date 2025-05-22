import { MissionRecipeSet } from "./MissionRecipeSet";
import { Model } from "./Model";
import { BelongsToMany } from "./Relationships/BelongsToMany";

export class Recipe extends Model {
    id: number;
    number: number;
    craftType: number;
    recipeLevelTable: number;
    output_item: number;
    output_amount: number;

    inputs: { item: number; amount: number }[];

    recipeNotebookList: number;
    displayPriority: number;
    isSecondary: boolean;

    materialQualityFactor: number;
    difficultyFactor: number;
    qualityFactor: number;
    durabilityFactor: number;
    requiredQuality: number;
    requiredCraftsmanship: number;
    requiredControl: number;
    quickSynthCraftsmanship: number;
    quickSynthControl: number;

    secretRecipeBook: number;
    quest: number;

    canQuickSynth: boolean;
    canHq: boolean;
    expRewarded: boolean;

    requiredStatus: number;
    requiredItem: number;

    isSpecializationRequired: boolean;
    isExpert: boolean;

    patchNumber: number;

    constructor(data: any) {
        super();

        this.id = Number(data.id);
        this.number = Number(data.Number);
        this.craftType = Number(data.CraftType);
        this.recipeLevelTable = Number(data.RecipeLevelTable);
        this.output_item = Number(data.output_item);
        this.output_amount = Number(data.output_amount);

        this.inputs = [];
        for (let i = 0; i <= 7; i++) {
            const itemKey = `input_${i}_item`;
            const amountKey = `input_${i}_amount`;
            const item = Number(data[itemKey]);
            const amount = Number(data[amountKey]);
            if (item !== 0 && item !== -1) {
                this.inputs.push({ item, amount });
            }
        }

        this.recipeNotebookList = Number(data.RecipeNotebookList);
        this.displayPriority = Number(data.DisplayPriority);
        this.isSecondary =
            data.IsSecondary === "True" || data.IsSecondary === true;

        this.materialQualityFactor = Number(data.MaterialQualityFactor);
        this.difficultyFactor = Number(data.DifficultyFactor);
        this.qualityFactor = Number(data.QualityFactor);
        this.durabilityFactor = Number(data.DurabilityFactor);
        this.requiredQuality = Number(data.RequiredQuality);
        this.requiredCraftsmanship = Number(data.RequiredCraftsmanship);
        this.requiredControl = Number(data.RequiredControl);
        this.quickSynthCraftsmanship = Number(data.QuickSynthCraftsmanship);
        this.quickSynthControl = Number(data.QuickSynthControl);

        this.secretRecipeBook = Number(data.SecretRecipeBook);
        this.quest = Number(data.Quest);

        this.canQuickSynth =
            data.CanQuickSynth === "True" || data.CanQuickSynth === true;
        this.canHq = data.CanHq === "True" || data.CanHq === true;
        this.expRewarded =
            data.ExpRewarded === "True" || data.ExpRewarded === true;

        this.requiredStatus = Number(data["Status{Required}"]);
        this.requiredItem = Number(data["Item{Required}"]);

        this.isSpecializationRequired =
            data.IsSpecializationRequired === "True" ||
            data.IsSpecializationRequired === true;
        this.isExpert = data.IsExpert === "True" || data.IsExpert === true;

        this.patchNumber = Number(data.PatchNumber);
    }

    public mission_sets(): BelongsToMany<MissionRecipeSet> {
        const repo = Model.getRepository(MissionRecipeSet);
        const sets = repo
            .all()
            .filter((set) => set.recipe_ids.includes(this.id));
        return new BelongsToMany(sets);
    }

    public get_input_item_ids(): number[] {
        return this.inputs.map((input) => input.item).filter((id) => id > 0);
    }
}
