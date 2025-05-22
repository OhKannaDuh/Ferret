import { Model } from "./Model";

export class TodoText extends Model {
    id: number;
    text: string;

    constructor(data: any) {
        super();

        this.id = Number(data.id);
        this.text = data.text;
    }
}
