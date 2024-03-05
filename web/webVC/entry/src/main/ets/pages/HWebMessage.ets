

export class HWebMessage {
  name: string
  body: object
  callbackId: string
  params: object
  constructor(name: string, callbackId: string, body: object, params: object) {
    this.name = name
    this.callbackId = callbackId
    this.body = body
    this.params = params
  }
}