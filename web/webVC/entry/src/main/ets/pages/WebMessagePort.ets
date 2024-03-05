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
  ports: web_webview.WebMessagePort[] = [];
  @State sendFromEts: string = 'Send this message from ets to HTML';
  @State receivedFromHtml: string = 'Display received message send from HTML';

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
      // 展示接收到的来自HTML的内容
      Text(this.receivedFromHtml)
      // 输入框的内容发送到HTML
      TextInput({placeholder: 'Send this message from ets to HTML'})
        .onChange((value: string) => {
          this.sendFromEts = value;
        })
      Button('postMessage')
        .onClick(() => {
          try {
            // 1、创建两个消息端口。
            this.ports = this.webviewController.createWebMessagePorts();
            // 2、在应用侧的消息端口(如端口1)上注册回调事件。
            this.ports[1].onMessageEvent((result: web_webview.WebMessage) => {
              let msg = 'Got msg from HTML:';
              if (typeof(result) === 'string') {
                console.info(`received string message from html5, string is: ${result}`);
                msg = msg + result;
              } else if (typeof(result) === 'object') {
                if (result instanceof ArrayBuffer) {
                  console.info(`received arraybuffer from html5, length is: ${result.byteLength}`);
                  msg = msg + 'lenght is ' + result.byteLength;
                } else {
                  console.info('not support');
                }
              } else {
                console.info('not support');
              }
              this.receivedFromHtml = msg;
            })
            // 3、将另一个消息端口(如端口0)发送到HTML侧，由HTML侧保存并使用。
            this.webviewController.postMessage('__init_port__', [this.ports[0]], '*');
          } catch (error) {
            let e: business_error.BusinessError = error as business_error.BusinessError;
            console.error(`ErrorCode: ${e.code},  Message: ${e.message}`);
          }
        })

      // 4、使用应用侧的端口给另一个已经发送到html的端口发送消息。
      Button('SendDataToHTML')
        .onClick(() => {
          try {
            if (this.ports && this.ports[1]) {
              this.ports[1].postMessageEvent(this.sendFromEts);
            } else {
              console.error(`ports is null, Please initialize first`);
            }
          } catch (error) {
            let e: business_error.BusinessError = error as business_error.BusinessError;
            console.error(`ErrorCode: ${e.code},  Message: ${e.message}`);
          }
        })

      // 组件创建时，加载url
      Web({ src: $rawfile("message.html"), controller: this.webviewController })
    }
  }
}