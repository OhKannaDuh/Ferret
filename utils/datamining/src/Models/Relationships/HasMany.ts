export class HasMany<T> {
    constructor(private related: T[]) {}

    get(): T[] {
        return this.related;
    }
}
