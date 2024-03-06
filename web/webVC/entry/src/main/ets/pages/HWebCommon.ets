import fs from '@ohos.file.fs';
import buffer from '@ohos.buffer';
import fileUri from "@ohos.file.fileuri";
import common from '@ohos.app.ability.common';
import util from '@ohos.util';
import { BusinessError } from '@ohos.base';

// const filePath = './HWebRejectionJS.js'; // JavaScript文件路径
let context = getContext(this) as common.UIAbilityContext;
let filesDir = context.databaseDir;

export function HBWKJSRejection_js(): string {
  let str = ""

  // 异步获取
  // try {
  //   context.resourceManager.getRawFileContent("HWebRejectionJS.js", (error: BusinessError, value: Uint8Array) => {
  //     if (error != null) {
  //       console.error("error is " + error);
  //     } else {
  //       let rawFile = value;
  //       let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM : true });
  //       console.log("input num:");
  //       // let retStr = textDecoder.decodeWithStream( result , {stream: false});
  //       let jsStr = textDecoder.decodeWithStream( rawFile , {stream: false});
  //       console.log("jsStr = " + jsStr)
  //     }
  //   });
  // } catch (error) {
  //   let code = (error as BusinessError).code;
  //   let message = (error as BusinessError).message;
  //   console.error(`callback getRawFileContent failed, error code: ${code}, message: ${message}.`);
  // }

  // 同步获取
  try {
    let fileArr = context.resourceManager.getRawFileContentSync("HWebRejectionJS.js");
    let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM : true });
    str = textDecoder.decodeWithStream( fileArr , {stream: false});
  } catch (error) {
    let code = (error as BusinessError).code;
    let message = (error as BusinessError).message;
    console.error(`getRawFileContentSync failed, error code: ${code}, message: ${message}.`);
  }

  // let filePath = filesDir + '/pages/HWebRejectionJS'
  // let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE)
  // let buf = new ArrayBuffer(4096)
  // fs.readSync(file.fd, buf)
  // fs.closeSync(file)
  // let buf1 = buffer.from(buf)
  // str = buf1.toString()
  return str
}