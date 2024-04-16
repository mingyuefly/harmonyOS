import { CommonConstants as Const } from '../common/constants/CommonConstants';

@Component
export default struct SearchComponent {

  build() {
    Row() {
      Image($r('app.media.ic_search'))
        .width($r('app.float.search_width'))
        .height($r('app.float.search_height'))
        .margin({
          left: $r('app.float.search_margin_left'),
          right: $r('app.float.search_margin_right')
        })
      Text($r('app.string.search_text'))
        .fontSize($r('app.float.small_font_size'))
        .fontColor(Color.Black)
        .opacity(Const.SIXTY_OPACITY)
        .fontWeight(FontWeight.Normal)
    }
    .width(Const.FULL_WIDTH)
    .height($r('app.float.search_swiper_height'))
    .borderRadius($r('app.float.search_radius'))
    .backgroundColor(Color.White)
    .margin({top: $r('app.float.search_margin_top')})
  }

}