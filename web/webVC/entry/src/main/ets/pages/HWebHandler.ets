import web_webview from '@ohos.web.webview';
import {BusinessError} from '@ohos.base';
import business_error from '@ohos.base';
import uri from '@ohos.uri';
import router from '@ohos.router'
import map from '@hms.core.map.map';
import {HWebMessage} from './HWebMessage'
import {HMethods} from './HMethods'


export class HWebHandler {
  webviewController: web_webview.WebviewController = new web_webview.WebviewController()
  // methods: Map<string, Function> = new Map<string, Function>()
  messageMethods: Map<string, Function> = new Map<string, Function>()
  ports: web_webview.WebMessagePort[] = [];
  methods: HMethods = new HMethods()

  constructor(webVC: web_webview.WebviewController) {
    this.webviewController = webVC
    // this.addPort()
  }

  private getMethod(name: string): Function | undefined {
    return this.methods.getMethod(name)
  }

  /*
   * 添加消息传递端口
   */
  addPort() {
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
            msg = msg + 'length is ' + result.byteLength;
          } else {
            console.info('not support');
          }
        } else {
          console.info('not support');
        }
      })
      // 3、将另一个消息端口(如端口0)发送到HTML侧，由HTML侧保存并使用。
      this.webviewController.postMessage('__init_port__', [this.ports[0]], '*');
    } catch (error) {
      let e: business_error.BusinessError = error as business_error.BusinessError;
      console.error(`ErrorCode: ${e.code},  Message: ${e.message}`);
    }
  }

  /*
   * 应用侧回调前端侧方法(通过调用runJavaScript方法)
   */
  callback(callbackId: string, pipe: boolean, params: Object) {
    try {
      let msg: Record<string, Object> = {}
      msg["callbackId"] = callbackId
      msg["pipe"] = pipe
      msg["params"] = params
      let msgStr = JSON.stringify(msg)
      // 由于artTS是严格类型检查的，所以用json来做js和native的数据传递
      let jsStr: string = 'hebaoWkjs.callback('+msgStr+')'
      this.webviewController.runJavaScript(jsStr)
        .then((message: string) => {
          console.log(message)
        })
    } catch(error) {
      let e: business_error.BusinessError = error as business_error.BusinessError;
      console.error(`ErrorCode: ${e.code},  Message: ${e.message}`);
    }
  }

  /*
   * 应用侧回调前端侧方法(通过调用消息发送方法)
   */
  msgCallback(callbackId: string, pipe: boolean, params: Object) {
    // 之所以在这里添加ports，是因为要确保加载html页面后才能将ports发送给html页面，而在bulid页面又不支持这个方法的执行
    if (this.ports.length < 2) {
      this.addPort()
    }
    try {
      let msg: Record<string, Object> = {}
      msg["callbackId"] = callbackId
      msg["pipe"] = pipe
      msg["params"] = params
      let msgStr = JSON.stringify(msg)

      if (this.ports && this.ports[1]) {
        // this.ports[1].postMessageEvent('{"str1": "htmlTestD from native str1"}');
        this.ports[1].postMessageEvent(msgStr);
      } else {
        console.error(`ports is null, Please initialize first`);
      }
    } catch (error) {
      let e: business_error.BusinessError = error as business_error.BusinessError;
      console.error(`ErrorCode: ${e.code},  Message: ${e.message}`);
    }
  }

  /**
   * 前端侧调用应用侧方法
   * @param name1 调用应用侧方法名字
   * @param msg 前端侧传递给应用侧的参数
   * @returns
   */
  onMessage(name1: string, msg: string): string {
    // 由于artTS是严格类型检查的，所以用json来做js和native的数据传递
    let msgJson: object = JSON.parse(msg)
    let name: string = name1
    let body: object = msgJson["body"]
    let params: object = body["params"]
    let callbackId: string = msgJson["callbackId"]
    let message: HWebMessage = new HWebMessage(name, callbackId, body, params, this)
    let func = this.getMethod(name)
    if (func) {
      return func(message)
    } else {
      console.log(name + "方法不存在")
      return ""
    }
  }

  /**
   * 前端侧调用应用侧日志方法
   * @param msg 日志参数
   */
  hblog(msg: string) {
    console.log(msg)
  }


  /**
   * 测试
   * @param str
   * @returns
   */
  getInfoFromNativeA(str: string): string {
    console.log(str)
    this.webviewController.runJavaScript('htmlTest()')
      .then((message: string) => {
        console.log(message)
      })

    interface User {
      name: string;
    }
    let apple: (User | string) []= ['gfd',{ name : "apple"}]
    console.log('urlsss: '+JSON.stringify(apple));
    try {
      let result = JSON.stringify(apple)
      let js: string = 'test(' + result + ')'
      this.webviewController.runJavaScript(
        js,
        (error, result) => {
          if (error) {
            let e: business_error.BusinessError = error as business_error.BusinessError;
            console.error(`run JavaScript error, ErrorCode: ${e.code}, Message: ${e.message}`);
            return;
          }
          if (result) {
            // this.webResult = result
            console.info(`The test() return value is: ${result}`)
          }
        });
    } catch (error) {
      let e: business_error.BusinessError = error as business_error.BusinessError;
      console.error(`ErrorCode: ${e.code}, Message: ${e.message}`);
    }
    // this.webviewController.runJavaScript('htmlTestA("htmlTestA from native")')
    return "fromNativeA"
  }

}