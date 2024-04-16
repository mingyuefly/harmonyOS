import StyleConstants from '../common/constants/StyleConstants';

@Component
export default struct SearchInput {
  @State searchInput: string = '';
  @Link searchArr: Array<string>;

  build() {
    Flex({alignItems: ItemAlign.Center}){
      // Search component.
      Search({
        value: this.searchInput,
        placeholder: StyleConstants.SEARCH_PLACEHOLDER,
        icon: StyleConstants.SEARCH_ICON
      })
        .placeholderColor($r('app.color.placeholder_color'))
        .placeholderFont({size: $r('app.float.font_size')})
        .textFont({size: $r('app.float.font_size')})
        .height(StyleConstants.SEARCH_HEIGHT)
        .width(StyleConstants.SEARCH_WIDTH)
        .backgroundColor(Color.White)
        .margin({
          left: $r('app.float.margin_left'),
          right: $r('app.float.margin_right'),
          top: $r('app.float.margin_top_bottom'),
          bottom: $r('app.float.margin_top_bottom')
        })
        .border({
          width: $r('app.float.border_width'),
          color: $r('app.color.border_color'),
          radius: $r('app.float.border_radius'),
          style: BorderStyle.Solid
        })
        .onChange((value: string) => {
          this.searchInput = value;
        })
      // Search Text.
      Text($r('app.string.search'))
        .fontSize($r('app.float.font_size'))
        .fontColor($r('app.color.search_font_color'))
        .onClick(() => {
          if (this.searchInput !== '' && this.searchInput.trim().length > 0) {
            // Use unshift to add data to the array header.
            this.searchArr.unshift(this.searchInput.trim());
          }
          this.searchInput = '';
        })
    }
    .width(StyleConstants.FULL_PERCENT)
  }
}