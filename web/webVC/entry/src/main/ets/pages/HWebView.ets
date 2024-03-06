import web_webview from '@ohos.web.webview';
import business_error from '@ohos.base';
import uri from '@ohos.uri';
import router from '@ohos.router'
// import {WebPageData} from './WebManager'
import {HMethods} from './HMethods'
import {HBWKJSRejection_js} from './HWebCommon'

// class HMethods {
//   constructor() {
//
//   }
//
//   getInfoFromNative(str: string): string {
//     console.log(str)
//     return "fromNative"
//   }
//
//   test(): string {
//     console.log(("test call app success"))
//     return 'ArkTS Hello World!';
//   }
// }

@Entry
@Component
struct WebComponent {
  webviewController: web_webview.WebviewController = new web_webview.WebviewController();
  @State url: string = ""
  @State testObj: HMethods = new HMethods(this.webviewController);

  aboutToAppear(): void {
    // 配置Web开启调试模式
    web_webview.WebviewController.setWebDebuggingAccess(true);
    // let hsStr = HBWKJSRejection_js()
    // console.log("hsStr = " + hsStr)
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
            this.webviewController.registerJavaScriptProxy(this.testObj, "testObjNameH", ["test", "getInfoFromNative", "getInfoFromNativeA", "doCall"]);
          } catch (error) {
            let e: business_error.BusinessError = error as business_error.BusinessError;
            console.error(`ErrorCode: ${e.code},  Message: ${e.message}`);
          }
        })
      // 组件创建时，加载url
      // Web({ src: $rawfile("index1.html"), controller: this.webviewController })
      Web({src: $rawfile("index3.html"), controller: this.webviewController })
        // 将对象注入到web端
        .javaScriptProxy({
          object: this.testObj,
          name: "testObjNameH",
          methodList: ["test", "getInfoFromNative", "getInfoFromNativeA", "doCall", "onMessage"],
          controller: this.webviewController
        })
        .onPageBegin((event) => {
          let jsStr: string = HBWKJSRejection_js()
          this.webviewController.runJavaScript(jsStr)
        })
        .onPageEnd((event) => {
          this.testObj.addPort()
        })


    }
  }
}