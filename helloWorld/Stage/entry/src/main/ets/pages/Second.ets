import router from '@ohos.router';

@Entry
@Component
struct Second {
  @State message: string = 'Hi there'
  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button() {
          Text('Back')
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({
          top : 20
        })
        .backgroundColor('#0D9FFB')
        .width('40%')
        .height('5%')
        // 返回按钮绑定onClick事件，点击按钮时返回到第一页
        .onClick(()=>{
          console.info(`Succeeded in clicking the 'Back' button.`)
          try {
            router.back()
            console.info('Succeeded in returning to the first page.')
          } catch (error) {
            console.error(`Failed to return to the first page.Code is ${error.code}, message is ${error.message}`)
          }
        })
      }
      .width('100%')
    }
    .height('100%')

  }
}