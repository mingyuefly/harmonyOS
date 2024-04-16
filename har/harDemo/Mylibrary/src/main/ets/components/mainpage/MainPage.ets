
@Entry({ routeName: 'myLibraryPage' })
@Component
export struct MainPage {
  @State message: string = 'My Library';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}
