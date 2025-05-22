import { Mission } from "./Mission";
import { Model } from "./Model";
import { BelongsToOne } from "./Relationships/BelongsToOne";

export class MissionReward extends Model {
    mission_id: number;
    unk_0: number;
    unk_1: number;
    unk_2: number;
    cosmic_credits: number;
    lunar_credits: number;
    unk_5: number;

    job_index_1: number;
    exp_tier_1: number;
    exp_amount_1: number;

    job_index_2: number;
    exp_tier_2: number;
    exp_amount_2: number;

    job_index_3: number;
    exp_tier_3: number;
    exp_amount_3: number;

    constructor(data: any) {
        super();

        this.mission_id = Number(data.mission_id);
        this.unk_0 = Number(data.unk_0);
        this.unk_1 = Number(data.unk_1);
        this.unk_2 = Number(data.unk_2);
        this.cosmic_credits = Number(data.cosmic_credits);
        this.lunar_credits = Number(data.lunar_credits);
        this.unk_5 = Number(data.unk_5);

        this.job_index_1 = Number(data.job_index_1);
        this.exp_tier_1 = Number(data.exp_tier_1);
        this.exp_amount_1 = Number(data.exp_amount_1);

        this.job_index_2 = Number(data.job_index_2);
        this.exp_tier_2 = Number(data.exp_tier_2);
        this.exp_amount_2 = Number(data.exp_amount_2);

        this.job_index_3 = Number(data.job_index_3);
        this.exp_tier_3 = Number(data.exp_tier_3);
        this.exp_amount_3 = Number(data.exp_amount_3);
    }

    public mission(): BelongsToOne<Mission> {
        const repo = Model.getRepository(Mission);
        const mission = repo.find((m) => m.id === this.mission_id);
        return new BelongsToOne(mission);
    }

    public get_exp_rewards(): {
        job: number;
        tier: number;
        amount: number;
    }[] {
        const groups = [
            {
                job: this.job_index_1,
                tier: this.exp_tier_1,
                amount: this.exp_amount_1,
            },
            {
                job: this.job_index_2,
                tier: this.exp_tier_2,
                amount: this.exp_amount_2,
            },
            {
                job: this.job_index_3,
                tier: this.exp_tier_3,
                amount: this.exp_amount_3,
            },
        ];

        // Filter out any group where job_index is 0 or negative
        return groups.filter((group) => group.job > 0);
    }
}
