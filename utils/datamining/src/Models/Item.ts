import { Model } from "./Model";

export class Item extends Model {
    id: number;
    singular: string;
    plural: string;
    name: string;

    constructor(data: any) {
        super();

        this.id = Number(data.id);
        this.singular = data.singular;
        this.plural = data.plural;
        this.name = data.name;
    }
}
