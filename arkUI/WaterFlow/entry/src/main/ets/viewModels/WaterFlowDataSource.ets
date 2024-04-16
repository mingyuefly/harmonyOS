import ProductItem from '../viewmodels/ProductItem';


export class WaterFlowDataSource implements IDataSource {
  private dataArray: ProductItem[] = [];
  private listeners: DataChangeListener[] = [];

  /**
   * Set water flow data array.
   *
   * @param {ProductItem[]} productDataArray Displaying water flow Data.
   */
  public setDataArray(productDataArray: ProductItem[]): void {
    this.dataArray = productDataArray;
  }

  /**
   * Get the total number of data records.
   */
  public totalCount(): number {
    return this.dataArray.length;
  }

  /**
   * Get the data corresponding to the index.
   *
   * @param {number} index Data index.
   * @returns Return ProductItem.
   */
  public getData(index: number): ProductItem {
    return this.dataArray[index];
  }

  /**
   * Register a controller that changes data.
   *
   * @param {DataChangeListener} listener Data change listener
   */
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  /**
   * Register a controller that changes data.
   *
   * @param {DataChangeListener} listener  Data change listener
   */
  unregisterDataChangeListener(listener: DataChangeListener): void {
    let pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }
}



