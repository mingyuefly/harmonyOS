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
    // let globalGcmParams = this.genGcmParamsSpec();
    let globalGcmParams = this.genCBCParamsSpec();
    // Create a Cipher instance.
    let cipherAlgName = 'AES128|CBC|PKCS5';
    // let cipherAlgName = 'AES128|GCM|PKCS7';
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
      // .then(tag => {
      //   // In GCM mode, the encrypted authentication information needs to be obtained from the output of doFinal() and passed in globalGcmParams of init() in decryption.
      //   globalGcmParams.authTag = tag;
      //   return;
      // })
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