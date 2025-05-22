import { Model } from "./Model";
import { MoonItemInfo } from "./MoonItemInfo";
import { HasOne } from "./Relationships/HasOne";
import { TodoText } from "./TodoText";

export class Todo extends Model {
    id: number;
    0: string;
    1: string;
    2: string;
    3: string;
    moon_item_1_id: number;
    moon_item_1_amount: number;
    moon_item_2_id: number;
    moon_item_2_amount: number;
    moon_item_3_id: number;
    moon_item_3_amount: number;
    10: string;
    11: string;
    12: string;
    13: string;
    14: string;
    15: string;
    16: string;
    17: string;
    18: string;
    todo_text_id: number;

    constructor(data: any) {
        super();

        this.id = Number(data.id);
        this[0] = data[0];
        this[1] = data[1];
        this[2] = data[2];
        this[3] = data[3];
        this.moon_item_1_id = Number(data.moon_item_1_id);
        this.moon_item_1_amount = Number(data.moon_item_1_amount);
        this.moon_item_2_id = Number(data.moon_item_2_id);
        this.moon_item_2_amount = Number(data.moon_item_2_amount);
        this.moon_item_3_id = Number(data.moon_item_3_id);
        this.moon_item_3_amount = Number(data.moon_item_3_amount);
        this[10] = data[10];
        this[11] = data[11];
        this[12] = data[12];
        this[13] = data[13];
        this[14] = data[14];
        this[15] = data[15];
        this[16] = data[16];
        this[17] = data[17];
        this[18] = data[18];
        this.todo_text_id = Number(data.todo_text_id);
    }

    public text(): HasOne<TodoText> {
        const repo = Model.getRepository(TodoText);
        const text = repo.find((t) => t.id === this.todo_text_id);
        return new HasOne(text);
    }

    public moon_item_1_info(): HasOne<MoonItemInfo> {
        const repo = Model.getRepository(MoonItemInfo);
        const info = repo.find((t) => t.todo_item_id === this.moon_item_1_id);
        return new HasOne(info);
    }

    public moon_item_2_info(): HasOne<MoonItemInfo> {
        const repo = Model.getRepository(MoonItemInfo);
        const info = repo.find((t) => t.todo_item_id === this.moon_item_2_id);
        return new HasOne(info);
    }

    public moon_item_3_info(): HasOne<MoonItemInfo> {
        const repo = Model.getRepository(MoonItemInfo);
        const info = repo.find((t) => t.todo_item_id === this.moon_item_3_id);
        return new HasOne(info);
    }
}
