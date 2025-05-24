import fs from "fs";
import { Formatter } from "./Formatter";
import { Mission } from "./Models/Mission";
import { MissionRecipeSet } from "./Models/MissionRecipeSet";
import { MissionReward } from "./Models/MissionReward";
import { Model } from "./Models/Model";
import { Recipe } from "./Models/Recipe";
import { CsvRepository } from "./Repositories/CsvRepository";
import { Name } from "./Models/Name";
import { Todo } from "./Models/Todo";
import { MoonItemInfo } from "./Models/MoonItemInfo";
import { TodoText } from "./Models/TodoText";
import { Item } from "./Models/Item";

function load_repository<T>(m: {new(row: any): T}, path: string): CsvRepository<T> {
    return new CsvRepository<T>(path, (row) => new m(row))
}

function register_repository<T>(m: {new(row: any): T}, path: string) {
    Model.registerRepository(m, load_repository<T>(m, path));
}

const missions = load_repository<Mission>(Mission, "data/missions.csv");
Model.registerRepository(Mission, missions);

register_repository(MissionReward, "data/mission_reward.csv");
register_repository(MissionRecipeSet, "data/mission_recipe.csv");
register_repository(Recipe, "data/recipes.csv")
register_repository(Name, "names.csv")
register_repository(Todo, "data/todo.csv")
register_repository(TodoText, "data/todo_text.csv")
register_repository(MoonItemInfo, "data/moon_item_info.csv")
register_repository(Item, "data/items.csv")

const formatter = new Formatter();
const jobs: Record<string, string[]> = {};

for (const mission of missions.all()) {
    const formatted = formatter.format(mission);
    let jobKey = mission.job.toString();
    if (mission.is_critical) {
        jobKey = "critical";
    }

    if (!jobs[jobKey]) {
        jobs[jobKey] = [];
    }

    jobs[jobKey].push(formatted);
}

const output_map = {
    "8": "Carpenter",
    "9": "Blacksmith",
    "10": "Armorer",
    "11": "Goldsmith",
    "12": "Leatherworker",
    "13": "Weaver",
    "14": "Alchemist",
    "15": "Culinarian",
    "16": "Miner",
    "17": "Botanist",
    "18": "Fisher",
    critical: "Critical",
};

Object.entries(output_map).forEach(([key, file]) => {
    const output = `return {\n${jobs[key].join("\n")}\n}`;

    fs.writeFileSync(`output/SinusArdorum/${file}Missions.gen.lua`, output);
});
