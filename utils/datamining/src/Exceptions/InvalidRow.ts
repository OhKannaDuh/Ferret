export class InvalidRow extends Error {
    constructor(message: string, public row: Record<string, string>) {
      super(message);
      this.name = 'InvalidRow';
    }
  }
  