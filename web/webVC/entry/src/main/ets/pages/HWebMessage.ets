import {HWebHandler} from './HWebHandler'

export class HWebMessage {
  name: string // 应用侧方法名字
  body: object // 传给应用侧数据包
  callbackId: string // 应用侧回调前端侧ID
  params: object // 传给应用侧参数
  hbCallback: (res: Object) => void = (res: Object) => {} // 应用侧执行完前端侧的调用后回调前端侧
  callbackPiping: boolean = false // 回调参数是否保存长连接---默认问答式
  handler: HWebHandler
  constructor(name: string, callbackId: string, body: object, params: object, handler: HWebHandler) {
    this.name = name
    this.callbackId = callbackId
    this.body = body
    this.params = params
    this.handler = handler
    if (callbackId && callbackId.length > 0) {
      this.hbCallback = (res) => {
        this.handler.callback(this.callbackId, this.callbackPiping, res)
        // this.handler.msgCallback(this.callbackId, this.callbackPiping, res)
      }
    }
  }
}