import StyleConstants from '../common/constants/StyleConstants';

@Component
export default struct FlexLayout {
  @Link searchArr: Array<string>;
  build() {
    Scroll() {
      Flex({justifyContent: FlexAlign.Start, wrap: FlexWrap.Wrap}) {
        if (this.searchArr.length > 0) {
          ForEach(this.searchArr, (item: string) => {
            Text(`${item}`)
              .fontSize($r("app.float.flex_font_size"))
              .borderStyle(BorderStyle.Solid)
              .borderWidth($r('app.float.border_width'))
              .borderColor($r("app.color.flex_layout_color"))
              .borderRadius($r('app.float.border_radius'))
              .backgroundColor($r("app.color.flex_layout_color"))
              .padding({
                top: StyleConstants.FLEX_PADDING_TOP,
                bottom: StyleConstants.FLEX_PADDING_BOTTOM,
                left: StyleConstants.FLEX_PADDING_LEFT,
                right: StyleConstants.FLEX_PADDING_RIGHT
              })
              .margin({
                top: $r('app.float.flex_layout_margin'),
                right: $r('app.float.flex_layout_margin')
              })
              .textOverflow({overflow: TextOverflow.Ellipsis})
              .maxLines(StyleConstants.TEXT_MAX_LINE)
          }, (item: string) => JSON.stringify(item));
        }
      }
      .margin({
        left: $r('app.float.margin_left'),
        right: $r('app.float.margin_right')
      })
      .padding({bottom: $r('app.float.margin_left')})
    }
  }
}