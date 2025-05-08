const fs = require("fs");
const csv = require("csv-parser");
const { parse } = require("path");
const { type } = require("os");

const results = [];

const array_to_json = (array, key) => {
    const initialValue = {};
    return array.reduce((obj, item) => {
        return {
            ...obj,
            [item[key]]: item,
        };
    }, initialValue);
};

async function get_csv(path, s = ",") {
    return new Promise((resolve, reject) => {
        const results = [];

        fs.createReadStream(path)
            .pipe(csv({ separator: s }))
            .on("data", (data) => results.push(data))
            .on("end", () => resolve(results))
            .on("error", (err) => reject(err));
    });
}

function get_mission_job_from_id(id) {
    return (
        {
            9: "Jobs.Carpenter",
            10: "Jobs.Blacksmith",
            11: "Jobs.Armorer",
            12: "Jobs.Goldsmith",
            13: "Jobs.Leatherworker",
            14: "Jobs.Weaver",
            15: "Jobs.Alchemist",
            16: "Jobs.Culinarian",
            17: "Jobs.Miner",
            18: "Jobs.Botanist",
            19: "Jobs.Fisher",
        }[id] || "Jobs.Unknown"
    );
}

function get_mission_class_from_id(id) {
    return {
        1: "D",
        2: "C",
        3: "B",
        4: "A",
        5: "A2",
        6: "A3",
    }[id];
}

function parse_reward(input) {
    let reward = {
        cosmic: input.cosmic_credits,
        lunar: input.lunar_credits,
        exp: [],
    };

    if (input.exp_amount_1 > 0) {
        reward.exp.push({
            job: input.job_index_1,
            tier: input.exp_tier_1,
            amount: input.exp_amount_1,
        });
    }

    if (input.exp_amount_2 > 0) {
        reward.exp.push({
            job: input.job_index_2,
            tier: input.exp_tier_2,
            amount: input.exp_amount_2,
        });
    }

    if (input.exp_amount_3 > 0) {
        reward.exp.push({
            job: input.job_index_3,
            tier: input.exp_tier_3,
            amount: input.exp_amount_3,
        });
    }

    return reward;
}

function parse_recipes(recipe_link, recipes) {
    let data = {};

    for (let index = 1; index <= 7; index++) {
        const key = `recipe_id_${index}`;
        if (!recipe_link[key]) {
            continue;
        }

        let recipe = recipes[recipe_link[key]];
        if (!recipe) {
            continue;
        }

        data[recipe.output_item] = recipe;
    }

    let output = {};
    let ids = [];
    for (const [key, value] of Object.entries(data).reverse()) {
        ids.push(value.output_item);
        const index = ids.indexOf(value.output_item);

        output[index] = 1;
    }

    for (const [key, value] of Object.entries(data)) {
        for (let index = 0; index <= 7; index++) {
            const item_key = `input_${index}_item`;
            if (value[item_key] <= 0) {
                continue;
            }

            const amount_key = `input_${index}_amount`;

            const key = value[item_key];
            const amount = value[amount_key];

            const item_index = ids.indexOf(key);
            if (item_index < 0) {
                continue;
            }

            output[item_index] = amount;
        }
    }

    return output;
}

function parse_multi_craft_config(config) {
    const sortedEntries = Object.entries(config).sort((a, b) => b[1] - a[1]);
    config = {};
    sortedEntries.forEach(([key, value], index) => {
        config[index] = value;
    });

    let output = "{";

    for (const [key, value] of Object.entries(config)) {
        output += `[${key}] = ${value}, `;
    }

    return output + "}";
}

function get_restriction(mission) {
    switch (mission.restriction) {
        case "13":
            return { type: "weather", value: "Weather.UmbralWind" };
        case "14":
            return { type: "weather", value: "Weather.MoonDust" };
    }

    if (mission.restriction == 0) return null;

    return {
        type: "time",
        min: mission.restriction * 2 - 2,
        max: mission.restriction * 2,
    };
}

(async () => {
    try {
        console.log("Loading missions.csv");
        const missions = await get_csv("missions.csv");

        console.log("Loading mission_recipe.csv");
        const mission_receipe_link = array_to_json(
            await get_csv("mission_recipe.csv"),
            "mission"
        );

        console.log("Loading recipes.csv");
        const recipes = array_to_json(await get_csv("recipes.csv"), "id");

        console.log("Loading mission_reward.csv");
        const mission_reward = array_to_json(
            await get_csv("mission_reward.csv"),
            "mission"
        );

        console.log("Loading mission_name_table.csv");
        const mission_names = array_to_json(
            await get_csv("names.csv"),
            "mission"
        );

        const data = {};
        missions.forEach((mission) => {
            let datum = {};

            // Mission data
            datum.id = mission.key;
            datum.name = mission.name.replace(" ", "");
            datum.job_id = mission.job;
            datum.job = get_mission_job_from_id(mission.job);
            datum.class = get_mission_class_from_id(mission.class);
            datum.time_limit = mission.time_limit;
            datum.silver_threshold = mission.silver;
            datum.gold_threshold = mission.gold;
            // datum.secondary_job = mission.secondary_job;
            datum.restriction = get_restriction(mission);
            datum.wks_recipe = mission.recipe;

            // Rewards
            datum.reward = parse_reward(mission_reward[datum.id]);

            // Recipe data
            const recipe_link = mission_receipe_link[datum.wks_recipe];
            if (recipe_link) {
                datum.multi_recipe = recipe_link.recipe_id_2 != 0;
                datum.multi_craft_config = parse_recipes(recipe_link, recipes);
            }

            data[datum.id] = datum;
        });

        let master_output = {
            9: "",
            10: "",
            11: "",
            12: "",
            13: "",
            14: "",
            15: "",
            16: "",
            17: "",
            18: "",
            19: "",
        };
        for (const [key, datum] of Object.entries(data)) {
            let output = `[${key}] = Mission(${datum.id}, Name("${datum.name}"), ${datum.job}, "${datum.class}")`;

            output += "\n\t" + `:with_de_name("${mission_names[datum.id].de}")`;
            output += "\n\t" + `:with_fr_name("${mission_names[datum.id].fr}")`;
            output += "\n\t" + `:with_jp_name("${mission_names[datum.id].jp}")`;

            if (datum.time_limit > 0) {
                output += "\n\t" + `:with_time_limit(${datum.time_limit})`;
            }

            if (datum.silver_threshold > 0) {
                output +=
                    "\n\t" +
                    `:with_silver_threshold(${datum.silver_threshold})`;
            }

            if (datum.gold_threshold > 0) {
                output +=
                    "\n\t" + `:with_gold_threshold(${datum.gold_threshold})`;
            }

            if (datum.secondary_job > 0) {
                output +=
                    "\n\t" + `:with_secondary_job(${datum.secondary_job})`;
            }

            if (datum.reward.cosmic) {
                output += "\n\t" + `:with_cosmocredit(${datum.reward.cosmic})`;
            }

            if (datum.reward.lunar) {
                output += "\n\t" + `:with_lunarcredit(${datum.reward.lunar})`;
            }

            datum.reward.exp.forEach((exp) => {
                output +=
                    "\n\t" +
                    `:with_exp_reward(MissionReward(${exp.job}, ${exp.tier}, ${exp.amount}))`;
            });

            if (datum.multi_recipe) {
                output += "\n\t" + `:with_multiple_recipes()`;
                output +=
                    "\n\t" +
                    `:with_multi_craft_config(${parse_multi_craft_config(
                        datum.multi_craft_config
                    )})`;
            }

            if (datum.restriction) {
                if (datum.restriction.type == "time") {
                    output +=
                        "\n\t" +
                        `:with_time_restriction(${datum.restriction.min}, ${datum.restriction.max})`;
                }

                if (datum.restriction.type == "weather") {
                    output +=
                        "\n\t" +
                        `:with_weather_restriction(${datum.restriction.value})`;
                }
            }

            output += ",\n";

            master_output[datum.job_id] += output;
        }

        function job_id_to_name(id) {
            return (
                {
                    9: "Carpenter",
                    10: "Blacksmith",
                    11: "Armorer",
                    12: "Goldsmith",
                    13: "Leatherworker",
                    14: "Weaver",
                    15: "Alchemist",
                    16: "Culinarian",
                    17: "Miner",
                    18: "Botanist",
                    19: "Fisher",
                }[id] || "Unknown"
            );
        }

        for (const [job, output] of Object.entries(master_output)) {
            const name = job_id_to_name(job);

            fs.writeFileSync(
                __dirname + "/output/SinusArdorum/" + name + "Missions.gen.lua",
                `return {
    ${output}
}`
            );
        }

        // fs.writeFileSync("output.txt", master_output);
    } catch (err) {
        console.error("Failed to parse CSV:", err);
    }
})();
