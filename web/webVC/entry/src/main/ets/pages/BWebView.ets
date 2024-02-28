import web_webview from '@ohos.web.webview';
import business_error from '@ohos.base';
import uri from '@ohos.uri';
import router from '@ohos.router'
// import {WebPageData} from './WebManager'

class testClass {
  constructor() {
  }

  test(): string {
    console.log(("test call app success"))
    return 'ArkTS Hello World!';
  }

  toString(): void {
    console.log('Web Component toString');
  }
}

@Entry
@Component
struct WebComponent {
  webviewController: web_webview.WebviewController = new web_webview.WebviewController();
  @State url: string = ""
  @State testObj: testClass = new testClass();

  aboutToAppear(): void {
    // 配置Web开启调试模式
    web_webview.WebviewController.setWebDebuggingAccess(true);
  }
  build() {
    Column() {
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
      Button('refresh')
        .onClick(() => {
          try {
            this.webviewController.refresh();
          } catch (error) {
            let e: business_error.BusinessError = error as business_error.BusinessError;
            console.error(`ErrorCode: ${e.code},  Message: ${e.message}`);
          }
        })
      Button('Register JavaScript To Window')
        .onClick(() => {
          try {
            this.webviewController.registerJavaScriptProxy(this.testObj, "testObjName", ["test", "toString"]);
          } catch (error) {
            let e: business_error.BusinessError = error as business_error.BusinessError;
            console.error(`ErrorCode: ${e.code},  Message: ${e.message}`);
          }
        })
      // 组件创建时，加载url
      Web({ src: $rawfile("index.html"), controller: this.webviewController })
    }
  }
}