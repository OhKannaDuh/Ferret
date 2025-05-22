import { Mission } from "./Models/Mission";

import jobs from "./data/jobs.json";
import ranks from "./data/ranks.json";
import node_data from "./data/node_data.json";
import { NodeDistributionCalculator } from "./NodeDistribution";

export class Formatter {
    public format(mission: Mission): string {
        const job = jobs[mission.job.toString() as keyof typeof jobs];
        const rank = ranks[mission.class.toString() as keyof typeof ranks];

        const name = mission.name().get();
        const reward = mission.reward().get();
        const recipe_set = mission.recipe_set().get();
        const todo = mission?.todo().get();
        const order = recipe_set?.get_crafting_order();
        const amounts = recipe_set?.get_crafting_amount(order ?? []);
        const recipes = recipe_set?.recipes().get();

        let output = [];

        output.push(`[${mission.id}] = Mission(${mission.id}, Jobs.${job}, "${rank.rank}", ${rank.tier})`);

        output.push(`:with_en_name("${name?.en}")`);
        output.push(`:with_de_name("${name?.de}")`);
        output.push(`:with_fr_name("${name?.fr}")`);
        output.push(`:with_jp_name("${name?.jp}")`);

        let type = "Crafting";

        if (mission.secondary_job) {
            output.push(`:with_secondary_job(${mission.secondary_job})`);
            output.push(`:with_mission_type(MissionType.Hybrid)`);
        } else {
            if (mission.job < 16) {
                output.push(`:with_mission_type(MissionType.Crafting)`);
            } else {
                type = "Gathering";
                output.push(`:with_mission_type(MissionType.Gathering)`);
            }
        }

        if (mission.is_critical) {
            output.push(":is_critical()");
        }

        if (mission.time_limit) {
            output.push(`:with_time_limit(${mission.time_limit})`);
        }

        output.push(`:with_silver_threshold(${mission.gold})`);
        output.push(`:with_gold_threshold(${mission.silver})`);
        output.push(`:with_cosmocredit(${reward?.cosmic_credits})`);
        output.push(`:with_lunarcredit(${reward?.lunar_credits})`);

        for (const exp_reward of reward?.get_exp_rewards() ?? []) {
            output.push(`:with_exp_reward(MissionReward(${exp_reward.job}, ${exp_reward.tier}, ${exp_reward.amount}))`);
        }

        if (mission.restriction) {
            if (mission.restriction == 13) {
                output.push(":with_weather_restriction(Weather.UmbralWind)");
            }

            if (mission.restriction == 14) {
                output.push(":with_weather_restriction(Weather.MoonDust)");
            }

            if (mission.restriction < 13) {
                const max = mission.restriction * 2;
                output.push(`:with_time_restriction(${max - 2}, ${max})`);
            }
        }

        if (mission.recipe && recipes) {
            output.push(`:with_recipe_table_id(${mission.recipe})`);

            const recipe_data = [];
            for (const recipe of recipes) {
                recipe_data.push({
                    recipe: recipe.id,
                    item: recipe.output_item,
                });
            }

            output.push(`:with_recipes(${JSON.stringify(recipe_data).replaceAll("[", "{").replaceAll("]", "}").replaceAll(":", "=").replaceAll('"', "")})`);

            let index = 0;
            let craft_config: { [key: string]: number } = {};
            for (const amount of amounts ?? []) {
                craft_config[`[${index}]`] = amount[1];
                index++;
            }

            if (index > 1) {
                output.push(
                    `:with_multi_craft_config(${JSON.stringify(craft_config)

                        .replaceAll(":", "=")
                        .replaceAll('"', "")})`
                );
            }
        }

        if (type == "Gathering") {
            if (todo?.moon_item_1_id != 0) {
                let gathering_config: { [key: string]: number } = {};
                if (todo?.moon_item_1_id) {
                    gathering_config[`[${todo.moon_item_1_info().get()?.item_id}]`] = todo?.moon_item_1_amount;
                }

                if (todo?.moon_item_2_id) {
                    gathering_config[`[${todo.moon_item_2_info().get()?.item_id}]`] = todo?.moon_item_2_amount;
                }

                if (todo?.moon_item_3_id) {
                    gathering_config[`[${todo.moon_item_3_info().get()?.item_id}]`] = todo?.moon_item_3_amount;
                }

                output.push(":with_gathering_type(GatheringType.ItemCount)");
                output.push(`:with_gathering_config(${JSON.stringify(gathering_config).replaceAll(":", "=").replaceAll('"', "")})`);
            } else {
                let todo_text = todo?.text()?.get()?.text ?? "";
                todo_text = todo_text.replaceAll("\n", "\n --- ");

                const type_map = {
                    "Successful chains will be scored": "Chain",
                    "Instances of Gatherer's Boon will be scored": "Boon",
                    "Chains and instances of Gatherer's Boon will be scored": "ChainBoon",
                    "Collectability will be scored": "Collectability",
                    "Number of items and collectability will be scored": "CollectabilityItemCount",
                    "More time remaining will earn a higher score.": "TimeTrial",
                    "Largest fish caught will be scored.": "LargeFish",
                    "Number and size of fish will be scored.": "FishCountSize",
                    "Size of fish will be scored.": "FishSize",
                    "Greater variety will earn a higher score.": "Variety",
                };

                let assigned = false;
                for (const [key, value] of Object.entries(type_map)) {
                    if (todo_text.includes(key)) {
                        assigned = true;
                        output.push(`:with_gathering_type(GatheringType.${value})`);
                        break;
                    }
                }

                if (!assigned) {
                    output.push(`--- ${todo_text}`);
                    output.push(":with_gathering_type(GatheringType.Other)");
                }
            }

            let key = `${name?.en as string}_${job}` as keyof typeof node_data.missions;
            if (node_data.missions[key]) {
                const calculator = new NodeDistributionCalculator();

                for (const node of node_data.missions[key] ?? []) {
                    const pos = node.Position;
                    calculator.nodes.push(pos);
                    output.push(`:with_node(Node(${pos.X}, ${pos.Y}, ${pos.Z}))`);
                }

                if (calculator.isChainlike()) {
                    output.push(":with_gathering_node_layout(GatheringNodeLayout.Chain)");

                    const start = node_data.missions[key][0].Position;
                    const end = node_data.missions[key][node_data.missions[key].length - 1].Position;
                    output.push(`:with_chain_ends({Node(${start.X}, ${start.Y}, ${start.Z}), Node(${end.X}, ${end.Y}, ${end.Z})})`);
                } else {
                    output.push(":with_gathering_node_layout(GatheringNodeLayout.Clustered)");

                    const clusters = calculator.groupIntoClusters(66);
                    let cluster_averages = [];
                    for (const cluster of clusters) {
                        let avgX = 0,
                            avgY = 0,
                            avgZ = 0;
                        for (const node of cluster) {
                            avgX += node.X;
                            avgY += node.Y;
                            avgZ += node.Z;
                        }

                        const clusterSize = cluster.length;
                        cluster_averages.push({
                            X: calculator.roundTo(avgX / clusterSize, 3),
                            Y: calculator.roundTo(avgY / clusterSize, 3),
                            Z: calculator.roundTo(avgZ / clusterSize, 3),
                        });
                    }

                    for (const avg of cluster_averages) {
                        output.push(`:with_cluster(Node(${avg.X}, ${avg.Y}, ${avg.Z}))`);
                    }
                }

                // console.log();
            }
        }

        return output.join("\n    ") + ",";
    }
}
