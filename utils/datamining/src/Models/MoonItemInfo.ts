import { Item } from "./Item";
import { Model } from "./Model";
import { HasOne } from "./Relationships/HasOne";

export class MoonItemInfo extends Model {
    todo_item_id: number;
    item_id: number;

    constructor(data: any) {
        super();

        this.todo_item_id = Number(data.todo_item_id);
        this.item_id = Number(data.item_id);
    }

    public item(): HasOne<Item> {
        const repo = Model.getRepository(Item);
        const item = repo.find((t) => t.id === this.item_id);
        return new HasOne(item);
    }
}
