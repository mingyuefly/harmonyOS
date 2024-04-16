import router from '@ohos.router';
import { BusinessError } from '@ohos.base';
import('Mylibrary');  // 引入共享包中的命名路由页面

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => { // 点击跳转到其他共享包中的页面
            try {
              router.pushNamedRoute({
                name: 'myLibraryPage',
                // params: {
                //   data1: 'message',
                //   data2: {
                //     data3: [123, 456, 789]
                //   }
                // }
              })
            } catch (err) {
              let message = (err as BusinessError).message
              let code = (err as BusinessError).code
              console.error(`pushNamedRoute failed, code is ${code}, message is ${message}`);
            }
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}