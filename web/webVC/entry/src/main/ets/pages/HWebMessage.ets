import {HMethods} from './HMethods'

export class HWebMessage {
  name: string
  body: object
  callbackId: string
  params: object
  hbCallback: (res: Object) => void = (res: Object) => {}
  handler: HMethods
  constructor(name: string, callbackId: string, body: object, params: object, handler: HMethods) {
    this.name = name
    this.callbackId = callbackId
    this.body = body
    this.params = params
    this.handler = handler
    if (callbackId && callbackId.length > 0) {
      this.hbCallback = (res) => {
        this.handler.callback(this.callbackId, res)
        // this.handler.msgCallback(this.callbackId, res)
      }
    }
  }
}