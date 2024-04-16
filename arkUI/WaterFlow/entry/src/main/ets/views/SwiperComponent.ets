import { CommonConstants as Const } from '../common/constants/CommonConstants';
import {swiperImage} from '../viewModels/HomeViewModel'

@Component
export default struct SwiperComponent {
  private dotIndicator: DotIndicator = new DotIndicator();
  aboutToAppear(): void {
    this.dotIndicator.selectedColor($r('app.color.indicator_select'));
  }
  build() {
    Swiper() {
      ForEach(swiperImage, (item: Resource) => {
        Image(item)
          .width(Const.FULL_WIDTH)
          .height($r('app.float.swiper_image_height'))
          .borderRadius($r('app.float.swiper_radius'))
          .backgroundColor(Color.White)
      }, (item: Resource) => JSON.stringify(item));
    }
    .indicator(this.dotIndicator)
    .autoPlay(true)
    .itemSpace(0)
    .width(Const.FULL_WIDTH)
    .displayCount(1)
    .margin({
      top: $r('app.float.swiper_margin_top'),
      bottom: $r('app.float.swiper_margin_bottom')
    })
  }
}