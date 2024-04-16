import {CommonConstants} from '../common/constants/CommonConstants';
import SearchComponent from '../views/SearchComponent';
import ClassifyComponent from '../views/ClassifyComponent';
import SwiperComponent from '../views/SwiperComponent';
import WaterFlowComponent from '../views/WaterFlowComponent';

@Entry
@Component
struct HomePage {

  build() {
    Stack({alignContent: Alignment.Top}) {
      Image($r('app.media.ic_app_background'))
        .width(CommonConstants.FULL_WIDTH)
        .height($r('app.float.image_background_height'))
        .objectFit(ImageFit.Cover)
      Column() {
        SearchComponent();
        ClassifyComponent();
        SwiperComponent();
        WaterFlowComponent();
      }
      .padding({
        left: $r('app.float.home_margin_left'),
        right: $r('app.float.home_margin_right')
      })
    }
    .backgroundColor($r('app.color.home_background_color'))
  }
}