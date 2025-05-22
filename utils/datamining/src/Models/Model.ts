import { CsvRepository } from "../Repositories/CsvRepository";

export class Model {
    static repositoryMap = new Map<Function, any>();

    static registerRepository<T>(cls: Function, repo: CsvRepository<T>) {
        Model.repositoryMap.set(cls, repo);
    }

    static getRepository<T>(cls: new (...args: any[]) => T): CsvRepository<T> {
        const repo = Model.repositoryMap.get(cls);
        if (!repo) {
            throw new Error(`Repository not registered for ${cls.name}`);
        }
        return repo;
    }
}
