import fs from '@ohos.file.fs';
import buffer from '@ohos.buffer';
import fileUri from "@ohos.file.fileuri";
import common from '@ohos.app.ability.common';

// const filePath = './HWebRejectionJS.js'; // JavaScript文件路径
let context = getContext(this) as common.UIAbilityContext;
let filesDir = context.databaseDir;

export function HBWKJSRejection_js(): string {
  let str = ""
  let filePath = filesDir + '/pages/HWebRejectionJS'
  let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE)
  let buf = new ArrayBuffer(4096)
  fs.readSync(file.fd, buf)
  fs.closeSync(file)
  let buf1 = buffer.from(buf)
  str = buf1.toString()
  return str
}