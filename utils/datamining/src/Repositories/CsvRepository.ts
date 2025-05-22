import  fs  from "fs";
import Papa from "papaparse";

export class CsvRepository<T> {
  private items: T[] = [];

  constructor(private path: string, private readonly fromRow: (row: any) => T) {
    this.load()
  }

  load(): void {
    const csv = fs.readFileSync(this.path).toString();
    const parsed = Papa.parse(csv, {
      header: true,
      skipEmptyLines: true,
      dynamicTyping: false, // We handle conversion ourselves
    });

    if (parsed.errors.length > 0) {
      console.error("CSV parse errors:", parsed.errors);
      throw new Error("Failed to parse CSV data");
    }

    this.items = parsed.data.map((row: any) => this.fromRow(row));
  }

  all(): T[] {
    return this.items;
  }

  find(predicate: (item: T) => boolean): T | undefined {
    return this.items.find(predicate);
  }

  filter(predicate: (item: T) => boolean): T[] {
    return this.items.filter(predicate);
  }

  get length(): number {
    return this.items.length;
  }

  clear(): void {
    this.items = [];
  }
}
