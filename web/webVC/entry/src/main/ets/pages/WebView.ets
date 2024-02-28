import web_webview from '@ohos.web.webview';
import business_error from '@ohos.base';
import uri from '@ohos.uri';
import router from '@ohos.router'
// import {WebPageData} from './WebManager'

class testClass {
  constructor() {
  }

  test(): string {
    return 'ArkTS Hello World!';
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
      Button('loadUrl')
        .onClick(() => {
          try {
            // 点击按钮时，通过loadUrl，跳转到local1.html
            this.webviewController.loadUrl($rawfile("local1.html"));
          } catch (error) {
            let e: business_error.BusinessError = error as business_error.BusinessError;
            console.error(`ErrorCode: ${e.code},  Message: ${e.message}`);
          }
        })
      Button('runJavaScript')
        .onClick(() => {
          this.webviewController.runJavaScript('htmlTest()');
        })
      // 组件创建时，加载url
      Web({ src: $rawfile("local1.html"), controller: this.webviewController })
        // 将对象注入到web端
        .javaScriptProxy({
          object: this.testObj,
          name: "testObjName",
          methodList: ["test"],
          controller: this.webviewController
        })
    }
  }
}