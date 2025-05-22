import { MissionRecipeSet } from "./MissionRecipeSet";
import { MissionReward } from "./MissionReward";
import { Model } from "./Model";
import { Name } from "./Name";
import { HasOne } from "./Relationships/HasOne";
import { Todo } from "./Todo";

export class Mission extends Model {
    id: number;
    unk_1: number;
    job: number;
    secondary_job: number;
    unk_4: number;
    is_critical: boolean;
    class: number;
    time_limit: number;
    silver: number;
    gold: number;
    todo_id: number;
    unk_12: number;
    zone: number;
    restriction: number;
    unk_15: number;
    unk_16: number;
    unk_17: number;
    recipe: number;
    unk_19: number;
    unk_20: number;

    constructor(data: any) {
        super();

        this.id = Number(data.id);
        this.unk_1 = Number(data.unk_1);
        this.job = Number(data.job) - 1;
        this.secondary_job = Number(data.secondary_job);
        this.unk_4 = Number(data.unk_4);
        this.is_critical =
            data.is_critical === "True" || data.is_critical === true;
        this.class = Number(data.class);
        this.time_limit = Number(data.time_limit);
        this.silver = Number(data.silver);
        this.gold = Number(data.gold);
        this.todo_id = Number(data.todo);
        this.unk_12 = Number(data.unk_12);
        this.zone = Number(data.zone);
        this.restriction = Number(data.restriction);
        this.unk_15 = Number(data.unk_15);
        this.unk_16 = Number(data.unk_16);
        this.unk_17 = Number(data.unk_17);
        this.recipe = Number(data.recipe);
        this.unk_19 = Number(data.unk_19);
        this.unk_20 = Number(data.unk_20);
    }

    public reward(): HasOne<MissionReward> {
        const repo = Model.getRepository(MissionReward);
        const reward = repo.find((r) => r.mission_id == this.id);
        return new HasOne(reward);
    }

    public recipe_set(): HasOne<MissionRecipeSet> {
        const repo = Model.getRepository(MissionRecipeSet);
        const set = repo.find((r) => r.mission_id === this.recipe);
        return new HasOne(set);
    }

    public name(): HasOne<Name> {
        const repo = Model.getRepository(Name);
        const set = repo.find((n) => n.mission_id === this.id);
        return new HasOne(set);
    }

    public todo(): HasOne<Todo> {
        const repo = Model.getRepository(Todo);
        const todo = repo.find((t) => t.id === this.todo_id);
        return new HasOne(todo);
    }
}
