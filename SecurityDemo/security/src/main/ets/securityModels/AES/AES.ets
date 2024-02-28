import cryptoFramework from '@ohos.security.cryptoFramework';
import { BusinessError } from '@ohos.base';
import util from '@ohos.util';

// import buffer from '@ohos.buffer';

export class AES {
  static cipherAlgName256 = 'AES256|CBC|PKCS5'
  static symAlgName256 = 'AES256'
  static symKeyGenerator256 = cryptoFramework.createSymKeyGenerator(this.symAlgName256)
  static globalCipher256 = cryptoFramework.createCipher(this.cipherAlgName256)

  static cipherAlgName128 = 'AES128|CBC|PKCS5'
  static symAlgName128 = 'AES128'
  static symKeyGenerator128 = cryptoFramework.createSymKeyGenerator(this.symAlgName128)
  static globalCipher128 = cryptoFramework.createCipher(this.cipherAlgName128)

  static createAES256Key(): Uint8Array {
    return AES.getRandomUin8Array(32)
  }

  static createAES128Key(): Uint8Array {
    return AES.getRandomUin8Array(16)
  }

  static creatAESIv(): Uint8Array {
    return AES.getRandomUin8Array(16)
  }

  static getRandomUin8Array(length: number) {
    let arr = new Uint8Array(length)
    for (let i = 0; i < length; i++) {
      arr[i] = Math.floor(Math.random() * 10)
    }
    return arr
  }

  // concatUint8Array(arr1: Uint8Array, arr2: Uint8Array) {
  //   let arr = new Uint8Array(arr1.length + arr2.length);
  //   for (let i = 0; i < arr1.length; i++) {
  //     arr[i] = arr1[i];
  //   }
  //   for (let i = arr1.length; i < arr1.length + arr2.length; i++) {
  //     arr[i] = arr2[i - arr1.length];
  //   }
  //   return arr;
  // }

  // stringToUint8ArrayByUTF8(str: string) {
  //   let str1 = '\u00bd + \u00bc = \u00be';
  //   console.log(`${str1}: ${str1.length} characters, ${buffer.byteLength(str1, 'utf-8')} bytes`);
  // }

  // stringToUint8Array(str: string) {
  //   let arr = new Uint8Array(str.length);
  //   for (let i = 0, j = str.length; i < j; ++i) {
  //     arr[i] = str.charCodeAt(i);
  //   }
  //   return arr;
  // }

  // uint8ArrayToString(array: Uint8Array) {
  //   let arrayString = '';
  //   for (let i = 0; i < array.length; i++) {
  //     arrayString += String.fromCharCode(array[i]);
  //   }
  //   return arrayString;
  // }

  // uint8ArrayToString(array: Uint8Array) {
  //   let arrayString = '';
  //   let bytesArray: Array<number> = new Array(array.length)
  //   for (let i = 0; i < bytesArray.length; i++) {
  //     bytesArray[i] = array[i]
  //   }
  //   arrayString = this.byteToString(bytesArray)
  //   return arrayString;
  // }

  // stringToBytes(str: String): Array<number> {
  //   let bytes: Array<number> = new Array();
  //   let c: number;
  //   let len = str.length;
  //   for (let i = 0; i < len; i++) {
  //     c = str.charCodeAt(i);
  //     if (c >= 0x010000 && c <= 0x10FFFF) {
  //       bytes.push(((c >> 18) & 0x07) | 0xF0);
  //       bytes.push(((c >> 12) & 0x3F) | 0x80);
  //       bytes.push(((c >> 6) & 0x3F) | 0x80);
  //       bytes.push((c & 0x3F) | 0x80);
  //     } else if (c >= 0x000800 && c <= 0x00FFFF) {
  //       bytes.push(((c >> 12) & 0x0F) | 0xE0);
  //       bytes.push(((c >> 6) & 0x3F) | 0x80);
  //       bytes.push((c & 0x3F) | 0x80);
  //     } else if (c >= 0x000080 && c <= 0x0007FF) {
  //       bytes.push(((c >> 6) & 0x1F) | 0xC0);
  //       bytes.push((c & 0x3F) | 0x80);
  //     } else {
  //       bytes.push(c & 0xFF);
  //     }
  //   }
  //   return bytes;
  // }

  // stringToBytesUint8Array(str: String): Uint8Array {
  //   let bytes: Array<number> = this.stringToBytes(str)
  //   let arr: Uint8Array = new Uint8Array(bytes.length)
  //   for (let i = 0; i < bytes.length; i++) {
  //     arr[i] = bytes[i]
  //   }
  //   return arr;
  // }

  // byteToString(byte: Array<number>): string {
  //   let str: string = '', _arr: Array<number> = byte;
  //   for (let i = 0; i < _arr.length; i++) {
  //     let one = _arr[i].toString(2),
  //       v = one.match("/^1+?(?=0)/");
  //     if (v && one.length == 8) {
  //       let bytesLength = v[0].length;
  //       let store = _arr[i].toString(2).slice(7 - bytesLength);
  //       for (let st = 1; st < bytesLength; st++) {
  //         store += _arr[st + i].toString(2).slice(2);
  //       }
  //       str += String.fromCharCode(parseInt(store, 2));
  //       i += bytesLength - 1;
  //     } else {
  //       str += String.fromCharCode(_arr[i]);
  //     }
  //   }
  //   return str;
  // }

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
    // let buffer = new ArrayBuffer(20);
    // let result = new Uint8Array(buffer);
    let result = new Uint8Array();
    // result = textEncoder.encodeInto("\uD800¥¥");
    result = textEncoder.encodeInto(str)
    // console.log("encode result = " + result.toString())
    return result
  }

  // genGcmParamsSpec() {
  //   let arr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; // 12 bytes
  //   let dataIv = new Uint8Array(arr);
  //   let ivBlob: cryptoFramework.DataBlob = { data: dataIv };
  //
  //   arr = [0, 0, 0, 0, 0, 0, 0, 0]; // 8 bytes
  //   let dataAad = new Uint8Array(arr);
  //   let aadBlob: cryptoFramework.DataBlob = { data: dataAad };
  //
  //   arr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; // 16 bytes
  //   let dataTag = new Uint8Array(arr);
  //   let tagBlob: cryptoFramework.DataBlob = {
  //     data: dataTag
  //   }; // The GCM authTag is obtained by doFinal() in encryption and passed in params of init() in decryption.
  //
  //   let gcmParamsSpec: cryptoFramework.GcmParamsSpec = {
  //     iv: ivBlob,
  //     aad: aadBlob,
  //     authTag: tagBlob,
  //     algName: "GcmParamsSpec"
  //   };
  //   return gcmParamsSpec;
  // }

  static genCBCParamsSpec(iv: Uint8Array) {
    // let arr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4]; // 16 bytes
    // let arr = this.creatAESIv()
    // let dataIv = new Uint8Array(arr);
    let dataIv = iv;
    let ivBlob: cryptoFramework.DataBlob = { data: dataIv };
    let cbcParamsSpec: cryptoFramework.IvParamsSpec = {
      iv: ivBlob,
      algName: "IvParamsSpec"
    }
    return cbcParamsSpec;
  }

  static async encrypt256(message: string, key: Uint8Array, iv: Uint8Array): Promise<cryptoFramework.DataBlob> {
    console.log("aes key1:" + key.toString())
    console.log(message)
    // let symAlgName = 'AES128'
    // let symKeyGenerator = cryptoFramework.createSymKeyGenerator(symAlgName)
    console.info(`symKeyGenerator algName: ${AES.symKeyGenerator256.algName}`)
    // Generate GCM parameter specifications.
    let globalCBCParams = AES.genCBCParamsSpec(iv)
    // let cipherAlgName = 'AES128|CBC|PKCS5';
    // let globalCipher = cryptoFramework.createCipher(cipherAlgName)
    console.info(`cipher algName: ${AES.globalCipher256.algName}`);
    // Use the key generator to randomly generate a 128-bit symmetric key.
    let aesKey: cryptoFramework.DataBlob = {data: key}
    let globalKey = await AES.symKeyGenerator256.convertKey(aesKey)
    let mode = cryptoFramework.CryptoMode.ENCRYPT_MODE;
    await AES.globalCipher256.init(mode, globalKey, globalCBCParams)
    let plainText: cryptoFramework.DataBlob = { data: AES.textEncodeByUtf8(message) };
    console.log(`plainText:${plainText.data.toString()}`)
    let globalCipherData = await AES.globalCipher256.doFinal(plainText)
    console.info(`doFinal cipher success.`);

    return globalCipherData
  }

  static async encrypt128(message: string, key: Uint8Array, iv: Uint8Array): Promise<cryptoFramework.DataBlob> {
    console.log("aes key1:" + key.toString())
    console.log(message)
    console.info(`symKeyGenerator algName: ${AES.symKeyGenerator128.algName}`)
    // Generate GCM parameter specifications.
    let globalCBCParams = AES.genCBCParamsSpec(iv)
    console.info(`cipher algName: ${AES.globalCipher128.algName}`);
    // Use the key generator to randomly generate a 128-bit symmetric key.
    let aesKey: cryptoFramework.DataBlob = {data: key}
    let globalKey = await AES.symKeyGenerator128.convertKey(aesKey)
    let mode = cryptoFramework.CryptoMode.ENCRYPT_MODE;
    await AES.globalCipher128.init(mode, globalKey, globalCBCParams)
    let plainText: cryptoFramework.DataBlob = { data: AES.textEncodeByUtf8(message) };
    console.log(`plainText:${plainText.data.toString()}`)
    let globalCipherData = await AES.globalCipher128.doFinal(plainText)
    console.info(`doFinal cipher success.`);

    return globalCipherData
  }

  static async decrypt256(message: cryptoFramework.DataBlob, key: Uint8Array, iv: Uint8Array): Promise<string> {
    console.log("aes key2:" + key.toString())
    console.log(message.data.toString())
    // let symAlgName = 'AES128'
    // let symKeyGenerator = cryptoFramework.createSymKeyGenerator(symAlgName)
    console.info(`symKeyGenerator algName: ${AES.symKeyGenerator256.algName}`)
    // Generate GCM parameter specifications.
    let globalCBCParams = AES.genCBCParamsSpec(iv)
    // let cipherAlgName = 'AES128|CBC|PKCS5';
    // let globalCipher = cryptoFramework.createCipher(cipherAlgName)
    console.info(`cipher algName: ${AES.globalCipher256.algName}`);
    // Use the key generator to randomly generate a 128-bit symmetric key.
    let aesKey: cryptoFramework.DataBlob = {data: key}
    let globalKey = await AES.symKeyGenerator256.convertKey(aesKey)
    let mode = cryptoFramework.CryptoMode.DECRYPT_MODE;
    await AES.globalCipher256.init(mode, globalKey, globalCBCParams)
    let plainText: cryptoFramework.DataBlob = message
    console.log(`plainText:${plainText.data.toString()}`)
    let globalCipherData = await AES.globalCipher256.doFinal(plainText)
    let decryptStr = AES.textDecodeByUtf8(globalCipherData.data)
    console.log(`decryptStr:${decryptStr}`)
    console.info(`doFinal cipher success.`);

    return decryptStr
  }

  static async decrypt128(message: cryptoFramework.DataBlob, key: Uint8Array, iv: Uint8Array): Promise<string> {
    console.log("aes key2:" + key.toString())
    console.log(message.data.toString())
    console.info(`symKeyGenerator algName: ${AES.symKeyGenerator128.algName}`)
    // Generate GCM parameter specifications.
    let globalCBCParams = AES.genCBCParamsSpec(iv)
    // let cipherAlgName = 'AES128|CBC|PKCS5';
    // let globalCipher = cryptoFramework.createCipher(cipherAlgName)
    console.info(`cipher algName: ${AES.globalCipher128.algName}`);
    // Use the key generator to randomly generate a 128-bit symmetric key.
    let aesKey: cryptoFramework.DataBlob = {data: key}
    let globalKey = await AES.symKeyGenerator128.convertKey(aesKey)
    let mode = cryptoFramework.CryptoMode.DECRYPT_MODE;
    await AES.globalCipher128.init(mode, globalKey, globalCBCParams)
    let plainText: cryptoFramework.DataBlob = message
    console.log(`plainText:${plainText.data.toString()}`)
    let globalCipherData = await AES.globalCipher128.doFinal(plainText)
    let decryptStr = AES.textDecodeByUtf8(globalCipherData.data)
    console.log(`decryptStr:${decryptStr}`)
    console.info(`doFinal cipher success.`);

    return decryptStr
  }


  aesEncryptA(message: string, key: Uint8Array) {
    console.log(message)
    let symAlgName = 'AES256';
    let symKeyGenerator = cryptoFramework.createSymKeyGenerator(symAlgName);
    console.info(`symKeyGenerator algName: ${symKeyGenerator.algName}`);
    // Generate GCM parameter specifications.
    // let globalGcmParams = this.genGcmParamsSpec();
    let globalGcmParams = AES.genCBCParamsSpec(AES.creatAESIv());
    // Create a Cipher instance.
    let cipherAlgName = 'AES256|CBC|PKCS5';
    let globalCipher = cryptoFramework.createCipher(cipherAlgName);
    console.info(`cipher algName: ${globalCipher.algName}`);
    // Use the key generator to randomly generate a 128-bit symmetric key.
    let globalCipherText: cryptoFramework.DataBlob;
    let globalCipherData: Uint8Array = new Uint8Array();
    let globalKey: cryptoFramework.SymKey;

    // let promiseSymKey = symKeyGenerator.generateSymKey();
    let aesKey: cryptoFramework.DataBlob = {data: key}
    let promiseSymKey = symKeyGenerator.convertKey(aesKey)
    promiseSymKey.then(key => {
      // Initialize the Cipher instance and start encryption.
      globalKey = key;
      console.log(`globalKey:${globalKey.algName}`);
      console.log(`globalKey:${globalKey.getEncoded().data.toString()}`);
      let mode = cryptoFramework.CryptoMode.ENCRYPT_MODE;
      return globalCipher.init(mode, globalKey, globalGcmParams);
    })
      .then(() => {
        // let plainText: cryptoFramework.DataBlob = { data: this.stringToUint8Array(message) };
        let plainText: cryptoFramework.DataBlob = { data: AES.textEncodeByUtf8(message) };
        console.log(`plainText:${plainText.data.toString()}`)
        return globalCipher.doFinal(plainText);
      })
      .then(finalOutput => {
        console.info(`doFinal cipher success.`);
        globalCipherText = finalOutput;
        // console.log(`doFinal output:${globalCipherText.data.toString()}`);
        if (globalCipherText != null) {
          console.log(`Finalize output:${globalCipherText.data.toString()}`);
          let finalizeText = AES.textDecodeByUtf8(globalCipherText.data)
          console.log(`finalizeText:${finalizeText}}`)
        }
        let mode = cryptoFramework.CryptoMode.DECRYPT_MODE;
        return globalCipher.init(mode, globalKey, globalGcmParams);
      })
      .then(() => {
        return globalCipher.doFinal(globalCipherText); // doFinal
      })
      .then(finalOutput => {
        console.info(`decrypt cipher success.`);
        console.info('decrypt plainText: ' + AES.textDecodeByUtf8(finalOutput.data));
        // console.info('decrypt plainText: ' + this.byteToString(finalOutput.data));
      })
      .catch((error: BusinessError) => {
        console.error(`catch error, ${error.code}, ${error.message}`);
      })
  }

  aesDecryptB(message: string) {
    console.log(message)
    let symAlgName = 'AES256';
    let symKeyGenerator = cryptoFramework.createSymKeyGenerator(symAlgName);
    console.info(`symKeyGenerator algName: ${symKeyGenerator.algName}`);
    // Generate GCM parameter specifications.
    // let globalGcmParams = this.genGcmParamsSpec();
    let iv1 = "adjw123891jsak12"
    let iv = new Uint8Array(iv1.length)
    for (let i = 0; i < iv1.length; i++) {
      iv[i] = iv1.charCodeAt(i)
    }
    let globalGcmParams = AES.genCBCParamsSpec(iv);
    // Create a Cipher instance.
    let cipherAlgName = 'AES256|CBC|PKCS5';
    let globalCipher = cryptoFramework.createCipher(cipherAlgName);
    console.info(`cipher algName: ${globalCipher.algName}`);
    // Use the key generator to randomly generate a 128-bit symmetric key.
    let globalCipherData: Uint8Array = new Uint8Array();
    for (let i = 0; i < message.length; i++) {
      globalCipherData[i] = message.charCodeAt(i)
    }
    let globalCipherText: cryptoFramework.DataBlob = {data: globalCipherData}
    let globalKey: cryptoFramework.SymKey;

    // let promiseSymKey = symKeyGenerator.generateSymKey();
    let key1 = "adjdkdjk334l4l2l4jklsalsal76ll12"
    let key2 = new Uint8Array(key1.length)
    for (let i = 0; i < key1.length; i++) {
      key2[i] = key1.charCodeAt(i)
    }
    let aesKey: cryptoFramework.DataBlob = {data: key2}
    let promiseSymKey = symKeyGenerator.convertKey(aesKey)
    promiseSymKey.then(key => {
      // Initialize the Cipher instance and start encryption.
      globalKey = key;
      console.log(`globalKey:${globalKey.algName}`);
      console.log(`globalKey:${globalKey.getEncoded().data.toString()}`);
      let mode = cryptoFramework.CryptoMode.DECRYPT_MODE;
      return globalCipher.init(mode, globalKey, globalGcmParams);
    })
      .then(() => {
        return globalCipher.doFinal(globalCipherText); // doFinal
      })
      .then(finalOutput => {
        console.info(`decryptB cipher success.`);
        console.info('decryptB plainText: ' + AES.textDecodeByUtf8(finalOutput.data));
        // console.info('decrypt plainText: ' + this.byteToString(finalOutput.data));
      })
      .catch((error: BusinessError) => {
        console.error(`catchB error, ${error.code}, ${error.message}`);
      })
  }

  aesEncrypt(message: string) {
    console.log(message)
    let symAlgName = 'AES128';
    let symKeyGenerator = cryptoFramework.createSymKeyGenerator(symAlgName);
    console.info(`symKeyGenerator algName: ${symKeyGenerator.algName}`);
    // Generate GCM parameter specifications.
    // let globalGcmParams = this.genGcmParamsSpec();
    let globalGcmParams = AES.genCBCParamsSpec(AES.creatAESIv());
    // Create a Cipher instance.
    let cipherAlgName = 'AES128|CBC|PKCS5';
    // let cipherAlgName = 'AES128|GCM|PKCS7';
    let globalCipher = cryptoFramework.createCipher(cipherAlgName);
    console.info(`cipher algName: ${globalCipher.algName}`);
    // Use the key generator to randomly generate a 128-bit symmetric key.
    let globalCipherText: cryptoFramework.DataBlob;
    let globalCipherData: Uint8Array = new Uint8Array();
    let globalKey: cryptoFramework.SymKey;
    let promiseSymKey = symKeyGenerator.generateSymKey();
    promiseSymKey.then(key => {
      // Initialize the Cipher instance and start encryption.
      globalKey = key;
      console.log(`globalKey:${globalKey.algName}`);
      console.log(`globalKey:${globalKey.getEncoded().data.toString()}`);
      let mode = cryptoFramework.CryptoMode.ENCRYPT_MODE;
      return globalCipher.init(mode, globalKey, globalGcmParams);
    })
      .then(() => {
        // let plainText: cryptoFramework.DataBlob = { data: this.stringToUint8Array(message) };
        // let plainText: cryptoFramework.DataBlob = { data: this.stringToBytesUint8Array(message) };
        let plainText: cryptoFramework.DataBlob = { data: AES.textEncodeByUtf8(message) };
        console.log(`plainText:${plainText.data.toString()}`)
        return globalCipher.doFinal(plainText);
      })
      .then(finalOutput => {
        console.info(`doFinal cipher success.`);
        globalCipherText = finalOutput;
        // console.log(`doFinal output:${globalCipherText.data.toString()}`);
        if (globalCipherText != null) {
          console.log(`Finalize output:${globalCipherText.data.toString()}`);
        }
        let mode = cryptoFramework.CryptoMode.DECRYPT_MODE;
        return globalCipher.init(mode, globalKey, globalGcmParams);
      })
      .then(() => {
        return globalCipher.doFinal(globalCipherText); // doFinal
      })
      .then(finalOutput => {
        console.info(`decrypt cipher success.`);
        // console.info('decrypt plainText: ' + this.uint8ArrayToString(finalOutput.data));
        console.info('decrypt plainText: ' + AES.textDecodeByUtf8(finalOutput.data));
        // console.info('decrypt plainText: ' + this.byteToString(finalOutput.data));
      })
      .catch((error: BusinessError) => {
        console.error(`catch error, ${error.code}, ${error.message}`);
      })
  }

  // aesEncryptB(message: string) {
  //   console.log(message)
  //   let symAlgName = 'AES128';
  //   let symKeyGenerator = cryptoFramework.createSymKeyGenerator(symAlgName);
  //   console.info(`symKeyGenerator algName: ${symKeyGenerator.algName}`);
  //   // Generate GCM parameter specifications.
  //   // let globalGcmParams = this.genGcmParamsSpec();
  //   let globalGcmParams = this.genCBCParamsSpec(this.creatAESIv());
  //   // Create a Cipher instance.
  //   let cipherAlgName = 'AES128|CBC|PKCS5';
  //   // let cipherAlgName = 'AES128|GCM|PKCS7';
  //   let globalCipher = cryptoFramework.createCipher(cipherAlgName);
  //   console.info(`cipher algName: ${globalCipher.algName}`);
  //   // Use the key generator to randomly generate a 128-bit symmetric key.
  //   let globalCipherText: cryptoFramework.DataBlob;
  //   let globalCipherData: Uint8Array = new Uint8Array();
  //   let globalKey: cryptoFramework.SymKey;
  //   let promiseSymKey = symKeyGenerator.generateSymKey();
  //   promiseSymKey.then(key => {
  //     // Initialize the Cipher instance and start encryption.
  //     globalKey = key;
  //     console.log(`globalKey:${globalKey.algName}`);
  //     console.log(`globalKey:${globalKey.getEncoded().data.toString()}`);
  //     let mode = cryptoFramework.CryptoMode.ENCRYPT_MODE;
  //     return globalCipher.init(mode, globalKey, globalGcmParams);
  //   })
  //     .then(() => {
  //       // let plainText: cryptoFramework.DataBlob = { data: this.stringToUint8Array('this is test!') };
  //       let plainText: cryptoFramework.DataBlob = { data: this.stringToUint8Array(message) };
  //       console.log(`plainText:${plainText.data.toString()}`)
  //       return globalCipher.update(plainText);
  //     })
  //     .then((updateOutput: cryptoFramework.DataBlob): Promise<cryptoFramework.DataBlob> => {
  //       console.info(`Update cipher success.`);
  //       if (updateOutput != null) {
  //         if (globalCipherData.length > 0) {
  //           let tmpData = this.concatUint8Array(globalCipherData, updateOutput.data);
  //           globalCipherText.data = tmpData;
  //         } else {
  //           globalCipherText = updateOutput;
  //         }
  //
  //         // globalCipherText = updateOutput;
  //         console.log(`update output:${globalCipherText.data.toString()}`);
  //         return globalCipher.doFinal(null);
  //       }
  //       return globalCipher.doFinal(updateOutput);
  //     })
  //
  //       // .then(tag => { // GCM
  //       //   // In GCM mode, the encrypted authentication information needs to be obtained from the output of doFinal() and passed in globalGcmParams of init() in decryption.
  //       //   globalGcmParams.authTag = tag;
  //       //   return;
  //       // })
  //     .then((finalOutput) => {
  //       // Initialize the Cipher instance and start decryption.
  //       console.info(`Finalize cipher success`);
  //       globalCipherText = finalOutput;
  //       if (globalCipherText != null) {
  //         console.log(`Finalize output:${globalCipherText.data.toString()}`);
  //       }
  //       let mode = cryptoFramework.CryptoMode.DECRYPT_MODE;
  //       return globalCipher.init(mode, globalKey, globalGcmParams);
  //     })
  //     .then(() => {
  //       return globalCipher.update(globalCipherText); // update
  //     })
  //     .then((updateOutput: cryptoFramework.DataBlob): Promise<cryptoFramework.DataBlob> => {
  //       if (updateOutput != null) {
  //         console.info('decrypt plainText: ' + this.uint8ArrayToString(updateOutput.data));
  //         return globalCipher.doFinal(null);
  //       }
  //       return globalCipher.doFinal(updateOutput);
  //     })
  //     .then(finalOutput => {
  //       if (finalOutput == null) { // Check whether the result is null before using finalOutput.data.
  //         console.info('GCM finalOutput is null');
  //       } else {
  //         console.info('decrypt plainText: ' + this.uint8ArrayToString(finalOutput.data));
  //       }
  //     })
  //     .catch((error: BusinessError) => {
  //       console.error(`catch error, ${error.code}, ${error.message}`);
  //     })
  // }
}
