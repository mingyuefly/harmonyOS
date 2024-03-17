import emitter from '@ohos.events.emitter';
import promptAction from '@ohos.promptAction';
// import Logger from '../utils/Logger';

const TAG: string = 'ThreadModel';


@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  aboutToAppear(): void {
    // 定义一个eventId为1的事件
    let event: emitter.InnerEvent = {
      eventId: 1
    };

    // 收到eventId为1的事件后执行该回调
    let callback = (eventData: emitter.EventData): void => {
      promptAction.showToast({
        message: JSON.stringify(eventData)
      });
      console.log(JSON.stringify(eventData));
    };

    // 订阅eventId为1的事件
    emitter.on(event, callback);
    // emitter.once(event, callback);
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('send', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(90)
          .height(40)
          .onClick(() => {
            // 定义一个eventId为1的事件，事件优先级为Low
            let event: emitter.InnerEvent = {
              eventId: 1,
              priority: emitter.EventPriority.LOW
            };

            let eventData: emitter.EventData = {
              data: {
                content: 'c',
                id: 1,
                isEmpty: false
              }
            };

            // 发送eventId为1的事件，事件内容为eventData
            emitter.emit(event, eventData);
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}