import { CommonConstants as Const } from '../common/constants/CommonConstants';
import {classifyTitle} from '../viewModels/HomeViewModel'

@Component
export default struct ClassifyComponent {
  @State titleIndex: number = 0;
  build() {
    Flex({justifyContent: FlexAlign.SpaceBetween}) {
      ForEach(classifyTitle, (item: Resource, index: number | undefined) => {
        if (index !== undefined) {
          Text(item)
            .fontSize($r('app.float.middle_font_size'))
            .opacity(this.titleIndex === index ? Const.FULL_OPACITY : Const.EIGHTY_OPACITY)
            .fontWeight(this.titleIndex === index ? Const.FONT_WEIGHT_FIVE: FontWeight.Normal)
            .fontColor(Color.White)
            .onClick(() => {
              this.titleIndex = index;
            })
        }
      }, (item: Resource) => JSON.stringify(item));

      Row() {
        Image($r('app.media.ic_split_line'))
          .width($r('app.float.split_line_width'))
          .height($r('app.float.split_line_height'))
        Image($r('app.media.ic_more'))
          .width($r('app.float.more_width'))
          .height($r('app.float.more_height'))
          .margin({
            left: $r('app.float.more_margin_left'),
            right: $r('app.float.more_margin_right')
          })
        Text($r('app.string.title_bar_classification'))
          .fontSize($r('app.float.middle_font_size'))
          .fontColor(Color.White)
          .opacity(this.titleIndex === Const.INVALID_INDEX ? Const.FULL_OPACITY : Const.EIGHTY_OPACITY)
          .fontWeight(this.titleIndex === Const.INVALID_INDEX ? Const.FONT_WEIGHT_FIVE : FontWeight.Normal)
      }
      .onClick(() => {
        this.titleIndex = Const.INVALID_INDEX;
      })
    }
    .width(Const.FULL_WIDTH)
    .margin({top: $r('app.float.classify_title_margin')})
  }
}