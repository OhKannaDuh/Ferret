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

const missions = new CsvRepository<Mission>(
    "data/missions.csv",
    (row) => new Mission(row)
);
const mission_rewards = new CsvRepository<MissionReward>(
    "data/mission_reward.csv",
    (row) => new MissionReward(row)
);
const mission_recipe = new CsvRepository<MissionRecipeSet>(
    "data/mission_recipe.csv",
    (row) => new MissionRecipeSet(row)
);
const recipes = new CsvRepository<Recipe>(
    "data/recipes.csv",
    (row) => new Recipe(row)
);
const names = new CsvRepository<Name>("names.csv", (row) => new Name(row));

const todo = new CsvRepository<Todo>("data/todo.csv", (row) => new Todo(row));

const todo_text = new CsvRepository<TodoText>(
    "data/todo_text.csv",
    (row) => new TodoText(row)
);

const moon_item_info = new CsvRepository<MoonItemInfo>(
    "data/moon_item_info.csv",
    (row) => new MoonItemInfo(row)
);

Model.registerRepository(Mission, missions);
Model.registerRepository(MissionReward, mission_rewards);
Model.registerRepository(MissionRecipeSet, mission_recipe);
Model.registerRepository(Recipe, recipes);
Model.registerRepository(Name, names);
Model.registerRepository(Todo, todo);
Model.registerRepository(TodoText, todo_text);
Model.registerRepository(MoonItemInfo, moon_item_info);

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
    "8": "CarpenterMissions.gen.lua",
    "9": "BlacksmithMissions.gen.lua",
    "10": "ArmorerMissions.gen.lua",
    "11": "GoldsmithMissions.gen.lua",
    "12": "LeatherworkerMissions.gen.lua",
    "13": "WeaverMissions.gen.lua",
    "14": "AlchemistMissions.gen.lua",
    "15": "CulinarianMissions.gen.lua",
    "16": "MinerMissions.gen.lua",
    "17": "BotanistMissions.gen.lua",
    "18": "FisherMissions.gen.lua",
    critical: "CriticalMissions.gen.lua",
};

Object.entries(output_map).forEach(([key, file]) => {
    const output = `return {\n${jobs[key].join("\n")}\n}`;

    fs.writeFileSync(`output/SinusArdorum/${file}`, output);
});
