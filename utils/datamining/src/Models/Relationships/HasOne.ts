export class HasOne<T> {
    constructor(private related: T | undefined) {}

    get(): T | undefined {
        return this.related;
    }
}
