import { Model } from "./Model";

export class MoonItemInfo extends Model {
    todo_item_id: number;
    item_id: number;

    constructor(data: any) {
        super();

        this.todo_item_id = Number(data.todo_item_id);
        this.item_id = Number(data.item_id);
    }
}
