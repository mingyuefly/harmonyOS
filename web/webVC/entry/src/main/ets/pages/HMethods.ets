import web_webview from '@ohos.web.webview';
import {BusinessError} from '@ohos.base';
import business_error from '@ohos.base';
import uri from '@ohos.uri';
import router from '@ohos.router'
import map from '@hms.core.map.map';
import {HWebMessage} from './HWebMessage'

export class HMethods {
  webviewController: web_webview.WebviewController = new web_webview.WebviewController()
  methods: Map<string, Function> = new Map<string, Function>()
  messageMethods: Map<string, Function> = new Map<string, Function>()
  ports: web_webview.WebMessagePort[] = [];

  constructor(webVC: web_webview.WebviewController) {
    this.webviewController = webVC
    // this.addPort()
    this.addMethods()
    this.addMessageMethods()
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
  callback(callId: string, params: Object) {
    try {
      let msg: Record<string, Object> = {}
      msg["callbackId"] = callId
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

    // let str: string = "'"
    // str += "callback("
    // str += '"'
    // str += callId
    // str += '"'
    // str += ","
    // // str += '"'
    // str += "'"
    // str += params
    // str += "'"
    // // str += '"'
    // str += ")"
    // str += "'"
    // console.log("func str:" + str)
    // this.webviewController.runJavaScript(str)
    //   .then((message: string) => {
    //     console.log(message)
    //   })
    //   .catch((error: BusinessError) => {
    //     console.error(`catch error, ${error.code}, ${error.message}`);
    //   })

  }

  /*
   * 应用侧回调前端侧方法(通过调用消息发送方法)
   */
  msgCallback(callId: string, params: Object) {
    // 之所以在这里添加ports，是因为要确保加载html页面后才能将ports发送给html页面，而在bulid页面又不支持这个方法的执行
    if (this.ports.length < 2) {
      this.addPort()
    }
    try {
      let msg: Record<string, Object> = {}
      msg["callId"] = callId
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

  addMethods() {
    this.methods.set("getInfoFromNativeB", (paramStr: string): string => {
      // 由于artTS是严格类型检查的，所以用json来做js和native的数据传递
      let params: object = JSON.parse(paramStr)
      console.log(params["str1"])
      this.webviewController.runJavaScript('htmlTest()')
        .then((message: string) => {
          console.log(message)
        })
      this.webviewController.runJavaScript('htmlTestB("htmlTestB from native")')
      return "fromNativeB"
    })
  }

  addMessageMethods() {
    this.messageMethods.set("getInfoFromNativeC", (message: HWebMessage): string => {
      // 由于artTS是严格类型检查的，所以用json来做js和native的数据传递
      let params: object = message.params
      console.log(params["str1"])
      this.webviewController.runJavaScript('htmlTest()')
        .then((message: string) => {
          console.log(message)
        })

      // this.webviewController.runJavaScript('htmlTestC("htmlTestC from native", "htmlTestC2 from native")')
      //   .then((message: string) => {
      //     console.log(message)
      //   })

      // {str3: "from C JSON"}
      let str3 = JSON.stringify({str3: "from C JSON"})
      let str: string = "'"
      str += "htmlTestC("
      str += '"'
      str += "htmlTestC from native"
      str += '"'
      str += ","
      str += '"'
      str += "htmlTestC2 from native"
      str += '"'
      str += ","
      str += "'"
      // str += "\\"
      str += str3
      str += "'"
      str += ')'
      str += "'"
      console.log(str)

      this.webviewController.runJavaScript(str)
        .then((message: string) => {
          console.log(message)
        })
      return "fromNativeC"
    })

    this.messageMethods.set("getInfoFromNativeD", (message: HWebMessage): string => {
      // 由于artTS是严格类型检查的，所以用json来做js和native的数据传递
      let params: object = message.params
      console.log(params["str1"])
      this.webviewController.runJavaScript('htmlTest()')
        .then((message: string) => {
          console.log(message)
        })
      this.callback(message.callbackId, '{"str1": "htmlTestD from native str1"}')
      return "fromNativeD"
    })

    this.messageMethods.set("getInfoFromNativeE", (message: HWebMessage): string => {
      let params: object = message.params;
      console.log(params["str1"]);
      console.log(params["str2"]);
      let callbackParams: Record<string, Object> = {};
      callbackParams["str1"] = "htmlTestE1";
      callbackParams["str2"] = "htmlTestE2";
      message.hbCallback(callbackParams)
      // this.msgCallback(message.callbackId, callbackParams)
      // this.callback(message.callbackId, callbackParams)
      return "fromNativeE"
    })
  }

  getInfoFromNative(str: string): string {
    console.log(str)
    this.webviewController.runJavaScript('htmlTest()')
    .then((message: string) => {
      console.log(message)
    })
    return "fromNative"
  }

  getInfoFromNativeA(str: string): string {
    console.log(str)
    this.webviewController.runJavaScript('htmlTest()')
      .then((message: string) => {
        console.log(message)
      })
    this.webviewController.runJavaScript('htmlTestA("htmlTestA from native")')
    return "fromNativeA"
  }

  getInfoFromNativeB(str: string): string {
    console.log(str)
    this.webviewController.runJavaScript('htmlTest()')
      .then((message: string) => {
        console.log(message)
      })
    return "fromNativeB"
  }

  doCall(name: string, params: string): string {
    let func = this.methods.get(name)
    if (func) {
      return func(params)
    } else {
      console.log(name + "方法不存在")
      return ""
    }
  }

  onMessage(name1: string, msg: string): string {
    // 由于artTS是严格类型检查的，所以用json来做js和native的数据传递
    let msgJson: object = JSON.parse(msg)
    let name: string = name1
    let body: object = msgJson["body"]
    let params: object = body["params"]
    let callbackId: string = msgJson["callbackId"]
    let message: HWebMessage = new HWebMessage(name, callbackId, body, params, this)
    let func = this.messageMethods.get(name)
    if (func) {
      return func(message)
    } else {
      console.log(name + "方法不存在")
      return ""
    }
  }

  test(): string {
    console.log(("test call app success"))
    return 'ArkTS Hello World!';
  }
}