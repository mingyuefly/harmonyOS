import ProductItem from '../viewmodels/ProductItem';
import { WaterFlowDataSource } from '../viewmodels/WaterFlowDataSource';
import { CommonConstants as Const } from '../common/constants/CommonConstants';
import { waterFlowData } from '../viewmodels/HomeViewModel';
import FlowItemComponent from '../views/FlowItemComponent';


@Component
export default struct WaterFlowComponent {
  private datasource: WaterFlowDataSource = new WaterFlowDataSource();
  aboutToAppear(): void {
    this.datasource.setDataArray(waterFlowData);
  }
  build() {
    WaterFlow({footer: (): void => this.itemFoot()}) {
      LazyForEach(this.datasource, (item: ProductItem) => {
        FlowItem() {
          FlowItemComponent({item: item})
        }
      }, (item: ProductItem) => JSON.stringify(item))
    }
    .layoutWeight(Const.WATER_FLOW_LAYOUT_WEIGHT)
    .layoutDirection(FlexDirection.Column)
    .columnsTemplate(Const.WATER_FLOW_COLUMNS_TEMPLATE)
    .columnsGap($r('app.float.water_flow_columns_gap'))
    .rowsGap($r('app.float.water_flow_row_gap'))
  }

  @Builder
  itemFoot() {
    Column() {
      Text($r('app.string.footer_text'))
        .fontColor(Color.Gray)
        .fontSize($r('app.float.footer_text_size'))
        .width(Const.FULL_WIDTH)
        .height($r('app.float.footer_text_height'))
        .textAlign(TextAlign.Center)
    }
  }
}