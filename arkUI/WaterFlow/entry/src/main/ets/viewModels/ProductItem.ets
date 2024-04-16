export interface IProductItem {
  /**
   * Product image url.
   */
  image_url: Resource;

  /**
   * Product name.
   */
  name: string;

  /**
   * Product discount.
   */
  discount: string;

  /**
   * Product price.
   */
  price: string;

  /**
   * Product promotion.
   */
  promotion: string;

  /**
   * Product bonus points.
   */
  bonus_points: string;
}

/**
 * Water flow item.
 */
export default class ProductItem implements IProductItem {
  image_url: Resource;
  name: string;
  discount: string;
  price: string;
  promotion: string;
  bonus_points: string;

  constructor(props: ProductItem) {
    this.image_url = props.image_url;
    this.name = props.name;
    this.discount = props.discount;
    this.price = props.price;
    this.promotion = props.promotion;
    this.bonus_points = props.bonus_points;
  }
}