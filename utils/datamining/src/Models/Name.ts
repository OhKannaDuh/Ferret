import { MissionRecipeSet } from "./MissionRecipeSet";
import { MissionReward } from "./MissionReward";
import { Model } from "./Model";
import { HasOne } from "./Relationships/HasOne";

export class Name extends Model {
    mission_id: number;
    en: string;
    de: string;
    fr: string;
    jp: string;

    constructor(data: any) {
        super();
        this.mission_id = Number(data.mission_id);
        this.en = data.en.replace(" ", "");
        this.de = data.de.replace(" ", "");
        this.fr = data.fr.replace(" ", "");
        this.jp = data.jp.replace(" ", "");
    }
}
