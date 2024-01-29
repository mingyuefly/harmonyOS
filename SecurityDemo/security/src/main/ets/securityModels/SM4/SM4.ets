import cryptoFramework from '@ohos.security.cryptoFramework';
import { BusinessError } from '@ohos.base';
import util from '@ohos.util';
import data from '@ohos.telephony.data';

// Convert strings in plaintext into byte streams.

export class SM4 {
  static stringToUint8Array(str: string) {
    let arr = new Uint8Array(str.length);
    for (let i = 0, j = str.length; i < j; ++i) {
      arr[i] = str.charCodeAt(i);
    }
    return arr;
  }

  // Convert byte streams into strings in plaintext.
  static uint8ArrayToString(array: Uint8Array) {
    let arrayString = '';
    for (let i = 0; i < array.length; i++) {
      arrayString += String.fromCharCode(array[i]);
    }
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
    let textEncoder = new util.TextEncoder();
    let buffer = new ArrayBuffer(20);
    let result = new Uint8Array(buffer);
    // result = textEncoder.encodeInto("\uD800¥¥");
    result = textEncoder.encodeInto(str)
    // console.log("encode result = " + result.toString())
    return result
  }

  static async encrypt(message: string, key: string): Promise<cryptoFramework.DataBlob> {
    // Create an AsyKeyGenerator instance.
    let sm4Generator = cryptoFramework.createSymKeyGenerator('SM4_128')
    // Create a Cipher instance for encryption.
    let cipher = cryptoFramework.createCipher("SM4_128|ECB|PKCS7")
    let input: cryptoFramework.DataBlob = { data: SM4.textEncodeByUtf8(message) }
    let keyData: cryptoFramework.DataBlob = {data: SM4.stringToUint8Array(key)}
    let key1: cryptoFramework.SymKey = await sm4Generator.convertKey(keyData)
    await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, key1, null)
    let data: cryptoFramework.DataBlob = await cipher.doFinal(input)
    return data
  }

  static async decrypt(message: cryptoFramework.DataBlob, key: string): Promise<string> {
    // Create an AsyKeyGenerator instance.
    let sm4Generator = cryptoFramework.createSymKeyGenerator('SM4_128')
    // Create a Cipher instance for encryption.
    let decoder = cryptoFramework.createCipher("SM4_128|ECB|PKCS7")
    let keyData: cryptoFramework.DataBlob = {data: SM4.stringToUint8Array(key)}
    let key1: cryptoFramework.SymKey = await sm4Generator.convertKey(keyData)
    await decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, key1, null)
    let data: cryptoFramework.DataBlob = await decoder.doFinal(message)
    let string = SM4.textDecodeByUtf8(data.data)
    return string
  }

  // SM4 ECB模式示例，callback写法
  // testSM4Ecb() {
  //   // Create an AsyKeyGenerator instance.
  //   let sm4Generator = cryptoFramework.createSymKeyGenerator('SM4_128');
  //   // Create a Cipher instance for encryption.
  //   let cipher = cryptoFramework.createCipher("SM4_128|ECB|PKCS7");
  //   // Create a Cipher instance for decryption.
  //   let decoder = cryptoFramework.createCipher("SM4_128|ECB|PKCS7");
  //
  //   let plainText = "this is cipher text";
  //   let input: cryptoFramework.DataBlob = { data: this.stringToUint8Array(plainText) };
  //
  //   let cipherData: cryptoFramework.DataBlob;
  //   let key: cryptoFramework.SymKey;
  //
  //   let keyString = "5BE4C0E990F04A339654D13D3A385A49"
  //   // let keyString = "5BE4C0E990F04A33"
  //   // const base = new util.Base64Helper
  //   // let keyData: cryptoFramework.DataBlob = {data: base.decodeSync(keyString)}
  //   let keyData: cryptoFramework.DataBlob = {data: this.stringToUint8Array(keyString)}
  //
  //   // let keyData = new Uint8Array([7, 154, 52, 176, 4, 236, 150, 43, 237, 9, 145, 166, 141, 174, 224, 131]);
  //   // let symKeyBlob: cryptoFramework.DataBlob = { data: keyData}
  //   // let symGenerator = cryptoFramework.createSymKeyGenerator('SM4_128');
  //   // let symKey = await symGenerator.convertKey(symKeyBlob);
  //
  //   // sm4Generator.generateSymKey()
  //   sm4Generator.convertKey(keyData)
  //     .then((symKey) => {
  //       key = symKey
  //       return cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, key, null)
  //     })
  //     .then(() => {
  //       return cipher.doFinal(input)
  //     })
  //     .then((encryptOutPut: cryptoFramework.DataBlob) => {
  //       AlertDialog.show({ message: "EncryptOutPut is " + encryptOutPut.data });
  //       cipherData = encryptOutPut;
  //     })
  //     .then(() => {
  //       return decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, key, null)
  //     })
  //     .then(() => {
  //       return decoder.doFinal(cipherData)
  //     })
  //     .then((decryData) => {
  //       AlertDialog.show({ message: "decrypt" + this.uint8ArrayToString(decryData.data) });
  //       if (input.data.toString() === decryData.data.toString()) {
  //         AlertDialog.show({ message: "decrypt success" });
  //         return;
  //       }
  //       AlertDialog.show({ message: "decrypt fail" });
  //     })
  //     .catch((err: BusinessError) => {
  //       console.log(JSON.stringify(err))
  //     })
  // }
}
