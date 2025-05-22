export class BelongsToOne<T> {
    constructor(private related: T | undefined) {}

    get(): T | undefined {
        return this.related;
    }
}
