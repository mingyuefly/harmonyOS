export class SM2_SEQUENCE{
  private _C1x: string = "";
  private _C1y: string = "";
  private _C2: string = "";
  private _C3: string = "";

  public set C1x(value: string) {
    this._C1x = value;
  }

  public get C1x(): string {
    return this._C1x;
  }

  public set C1y(value: string) {
    this._C1y = value;
  }

  public get C1y(): string {
    return this._C1y;
  }

  public set C2(value: string) {
    this._C2 = value;
  }

  public get C2(): string {
    return this._C2;
  }

  public set C3(value: string) {
    this._C3 = value;
  }

  public get C3(): string {
    return this._C3;
  }

  public toString():string{
    return JSON.stringify(this);
  }
}