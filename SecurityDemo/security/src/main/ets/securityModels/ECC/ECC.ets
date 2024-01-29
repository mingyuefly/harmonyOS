import cryptoFramework from '@ohos.security.cryptoFramework';
import { BusinessError } from '@ohos.base';

export class ECC {
  // Convert strings in plaintext into byte streams.
  stringToUint8Array(str: string) {
    let arr = new Uint8Array(str.length);
    for (let i = 0, j = str.length; i < j; ++i) {
      arr[i] = str.charCodeAt(i);
    }
    return arr;
  }

  Uint8ArrayToString(fileData:Uint8Array) {
    let dataString = '';
    for (let i = 0; i < fileData.length; i++) {
      dataString += String.fromCharCode(fileData[i]);
    }
    return dataString;
  }

  convertKeyFunc() {
    let pubKeyArray = new Uint8Array([48, 89, 48, 19, 6, 7, 42, 134, 72, 206, 61, 2, 1, 6, 8, 42, 134, 72, 206, 61, 3, 1, 7, 3, 66, 0, 4, 83, 96, 142, 9, 86, 214, 126, 106, 247, 233, 92, 125, 4, 128, 138, 105, 246, 162, 215, 71, 81, 58, 202, 121, 26, 105, 211, 55, 130, 45, 236, 143, 55, 16, 248, 75, 167, 160, 167, 106, 2, 152, 243, 44, 68, 66, 0, 167, 99, 92, 235, 215, 159, 239, 28, 106, 124, 171, 34, 145, 124, 174, 57, 92]);
    let priKeyArray = new Uint8Array([48, 49, 2, 1, 1, 4, 32, 115, 56, 137, 35, 207, 0, 60, 191, 90, 61, 136, 105, 210, 16, 27, 4, 171, 57, 10, 61, 123, 40, 189, 28, 34, 207, 236, 22, 45, 223, 10, 189, 160, 10, 6, 8, 42, 134, 72, 206, 61, 3, 1, 7]);
    let pubKeyBlob: cryptoFramework.DataBlob = {data: pubKeyArray}; // Data of the public key.
    let priKeyBlob: cryptoFramework.DataBlob = {data: priKeyArray}; // Data of the private key.
    let asyKeyGenerator = cryptoFramework.createAsyKeyGenerator("ECC256");
    asyKeyGenerator.convertKey(pubKeyBlob, priKeyBlob, (err, keyPair) => {
      if (err) {
        console.error("convertKey: error.");
        return;
      }
      console.info("convertKey: success.");
    })
  }
}