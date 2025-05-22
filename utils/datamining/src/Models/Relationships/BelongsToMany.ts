export class BelongsToMany<T> {
    constructor(private related: T[]) {}

    get(): T[] {
        return this.related;
    }
}
