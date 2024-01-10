import cryptoFramework from '@ohos.security.cryptoFramework';
import { BusinessError } from '@ohos.base';

export class AES {
  genGcmParamsSpec() {
    let arr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; // 12 bytes
    let dataIv = new Uint8Array(arr);
    let ivBlob: cryptoFramework.DataBlob = { data: dataIv };

    arr = [0, 0, 0, 0, 0, 0, 0, 0]; // 8 bytes
    let dataAad = new Uint8Array(arr);
    let aadBlob: cryptoFramework.DataBlob = { data: dataAad };

    arr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; // 16 bytes
    let dataTag = new Uint8Array(arr);
    let tagBlob: cryptoFramework.DataBlob = {
      data: dataTag
    }; // The GCM authTag is obtained by doFinal() in encryption and passed in params of init() in decryption.

    let gcmParamsSpec: cryptoFramework.GcmParamsSpec = {
      iv: ivBlob,
      aad: aadBlob,
      authTag: tagBlob,
      algName: "GcmParamsSpec"
    };
    return gcmParamsSpec;
  }

  genCBCParamsSpec() {
    let arr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; // 16 bytes
    let dataIv = new Uint8Array(arr);
    let ivBlob: cryptoFramework.DataBlob = { data: dataIv };
    let cbcParamsSpec: cryptoFramework.IvParamsSpec = {
      iv: ivBlob,
      algName: "IvParamsSpec"
    }
    return cbcParamsSpec;
  }

  stringToUint8Array(str: string) {
    let arr = new Uint8Array(str.length);
    for (let i = 0, j = str.length; i < j; ++i) {
      arr[i] = str.charCodeAt(i);
    }
    return arr;
  }

  uint8ArrayToString(array: Uint8Array) {
    let arrayString = '';
    for (let i = 0; i < array.length; i++) {
      arrayString += String.fromCharCode(array[i]);
    }
    return arrayString;
  }

  aesEncrypt(message: string) {
    console.log(message)
    let symAlgName = 'AES128';
    let symKeyGenerator = cryptoFramework.createSymKeyGenerator(symAlgName);
    console.info(`symKeyGenerator algName: ${symKeyGenerator.algName}`);
    // Generate GCM parameter specifications.
    let globalGcmParams = this.genGcmParamsSpec();
    // let globalGcmParams = this.genCBCParamsSpec();
    // Create a Cipher instance.
    // let cipherAlgName = 'AES128|CBC|PKCS5';
    let cipherAlgName = 'AES128|GCM|PKCS7';
    let globalCipher = cryptoFramework.createCipher(cipherAlgName);
    console.info(`cipher algName: ${globalCipher.algName}`);
    // Use the key generator to randomly generate a 128-bit symmetric key.
    let globalCipherText: cryptoFramework.DataBlob;
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
        let plainText: cryptoFramework.DataBlob = { data: this.stringToUint8Array('this is test!') };
        console.log(`plainText:${plainText.data.toString()}`)
        return globalCipher.update(plainText);
      })
      .then((updateOutput: cryptoFramework.DataBlob): Promise<cryptoFramework.DataBlob> => {
        globalCipherText = updateOutput;
        console.log(`update output:${globalCipherText.data.toString()}`);
        return globalCipher.doFinal(null);
      })
        .then(tag => {
          // In GCM mode, the encrypted authentication information needs to be obtained from the output of doFinal() and passed in globalGcmParams of init() in decryption.
          globalGcmParams.authTag = tag;
          return;
        })
      .then(() => {
        // Initialize the Cipher instance and start decryption.
        let mode = cryptoFramework.CryptoMode.DECRYPT_MODE;
        return globalCipher.init(mode, globalKey, globalGcmParams);
      })
      .then(() => {
        return globalCipher.update(globalCipherText); // update
      })
      .then((updateOutput: cryptoFramework.DataBlob): Promise<cryptoFramework.DataBlob> => {
        console.info('decrypt plainText: ' + this.uint8ArrayToString(updateOutput.data));
        return globalCipher.doFinal(null);
      })
      .then(finalOutput => {
        if (finalOutput == null) { // Check whether the result is null before using finalOutput.data.
          console.info('GCM finalOutput is null');
        }
      })
      .catch((error: BusinessError) => {
        console.error(`catch error, ${error.code}, ${error.message}`);
      })
  }
}







// import huks from '@ohos.security.huks'



// /*
//  * 以导入AES256密钥为例
//  */
//
// /* 密钥 */
// let plainTextSize32 = new Uint8Array([
//   0xfb, 0x8b, 0x9f, 0x12, 0xa0, 0x83, 0x19, 0xbe, 0x6a, 0x6f, 0x63, 0x2a, 0x7c, 0x86, 0xba, 0xca,
//   0x64, 0x0b, 0x88, 0x96, 0xe2, 0xfa, 0x77, 0xbc, 0x71, 0xe3, 0x0f, 0x0f, 0x9e, 0x3c, 0xe5, 0xf9
// ]);
//
// /*
//  * 确定密钥别名
//  */
// let keyAlias = 'AES256Alias_sample';
//
// /*
//  * 封装密钥属性集和密钥材料
//  */
// class propertyType {
//   tag: huks.HuksTag = huks.HuksTag.HUKS_TAG_ALGORITHM;
//   value: huks.HuksKeyAlg | huks.HuksKeySize | huks.HuksKeyPurpose = huks.HuksKeyAlg.HUKS_ALG_RSA;
// }
//
// let properties: propertyType[] = [
//   {
//     tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
//     value:huks.HuksKeyAlg.HUKS_ALG_AES
//   },
//   {
//     tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
//     value: huks.HuksKeySize.HUKS_AES_KEY_SIZE_256
//   },
//   {
//     tag: huks.HuksTag.HUKS_TAG_PURPOSE,
//     value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT | huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT
//   },
// ]
//
// let options: huks.HuksOptions = {
//   properties: properties,
//   inData: plainTextSize32
// };
//
// /*
//  * 导入密钥
//  */
// try {
//   huks.importKeyItem(keyAlias, options, (error, data) => {
//     if (error) {
//       console.error(`callback: importKeyItem failed`);
//     } else {
//       console.info(`callback: importKeyItem success`);
//     }
//   });
// } catch (error) {
//   console.error(`callback: importKeyItem input arg invalid`);
// }