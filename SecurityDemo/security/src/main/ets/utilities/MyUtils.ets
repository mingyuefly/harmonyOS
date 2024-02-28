import util from '@ohos.util';
import buffer from '@ohos.buffer';

// import {SM2} from '../securityModels/SM2/SM2'

export class MyUtils {
 static stringToBytes(str: String): Array<number> {
    let bytes: Array<number> = new Array();
    let c: number;
    let len = str.length;
    for (let i = 0; i < len; i++) {
      c = str.charCodeAt(i);
      if (c >= 0x010000 && c <= 0x10FFFF) {
        bytes.push(((c >> 18) & 0x07) | 0xF0);
        bytes.push(((c >> 12) & 0x3F) | 0x80);
        bytes.push(((c >> 6) & 0x3F) | 0x80);
        bytes.push((c & 0x3F) | 0x80);
      } else if (c >= 0x000800 && c <= 0x00FFFF) {
        bytes.push(((c >> 12) & 0x0F) | 0xE0);
        bytes.push(((c >> 6) & 0x3F) | 0x80);
        bytes.push((c & 0x3F) | 0x80);
      } else if (c >= 0x000080 && c <= 0x0007FF) {
        bytes.push(((c >> 6) & 0x1F) | 0xC0);
        bytes.push((c & 0x3F) | 0x80);
      } else {
        bytes.push(c & 0xFF);
      }
    }
    return bytes;
  }

  static byteToString(byte: Array<number>): string {
    let str: string = '', _arr: Array<number> = byte;
    for (let i = 0; i < _arr.length; i++) {
      let one = _arr[i].toString(2),
        v = one.match('/^1+?(?=0)/');
      if (v && one.length == 8) {
        let bytesLength = v[0].length;
        let store = _arr[i].toString(2).slice(7 - bytesLength);
        for (let st = 1; st < bytesLength; st++) {
          store += _arr[st + i].toString(2).slice(2);
        }
        str += String.fromCharCode(parseInt(store, 2));
        i += bytesLength - 1;
      } else {
        str += String.fromCharCode(_arr[i]);
      }
    }
    return str;
  }

  stringToBytesUint8Array(str: String): Uint8Array {
    let bytes: Array<number> = MyUtils.stringToBytes(str)
    let arr: Uint8Array = new Uint8Array(bytes.length)
    for (let i = 0; i < bytes.length; i++) {
      arr[i] = bytes[i]
    }
    return arr;
  }

  static stringToUint8Array(str: string) {
    let arr = new Uint8Array(str.length);
    for (let i = 0, j = str.length; i < j; ++i) {
      arr[i] = str.charCodeAt(i);
    }
    return arr;
  }

  static uint8ArrayToString(array: Uint8Array) {
    let arrayString = '';
    let bytesArray: Array<number> = new Array(array.length)
    for (let i = 0; i < bytesArray.length; i++) {
      bytesArray[i] = array[i]
    }
    arrayString = MyUtils.byteToString(bytesArray)
    return arrayString;
  }

  static textDecodeByUtf8(arr: Uint8Array): string {
    let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM : true });
    console.log("input num:");
    // let retStr = textDecoder.decodeWithStream( result , {stream: false});
    let retStr = textDecoder.decodeWithStream( arr , {stream: false});
    // console.log("retStr = " + retStr);
    return retStr
  }

  static textEncodeByUtf8(str: string): Uint8Array {
    let textEncoder = new util.TextEncoder()
    // let buffer = new ArrayBuffer(20);
    // let result = new Uint8Array(buffer);
    // result = textEncoder.encodeInto("\uD800¥¥");
    // result = textEncoder.encodeInto(str)
    // console.log("encode result = " + result.toString())
    let result = textEncoder.encodeInto(str)
    return result
  }

  static base64EncodeToString(str: string): string {
    let strBase64 = buffer.from(str).toString("base64")
    return strBase64
  }

  static base64EncodeToUint8Array(str: string): Uint8Array {
    let baseUtil = new util.Base64Helper
    let array = MyUtils.stringToUint8Array(str)
    return baseUtil.encodeSync(array)
  }
}
