import cryptoFramework from '@ohos.security.cryptoFramework';
import { BusinessError } from '@ohos.base';
import util from '@ohos.util';
// import hilog from '@ohos.hilog';
// import {MyUtils} from '../utilities/MyUtils'


let plan = "This is cipher test.";

export class RSA {
  // Convert strings in plaintext into byte streams.

  static rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA1024|PRIMES_2")
  arr: Uint8Array = new Uint8Array()
  globalDataBlob: cryptoFramework.DataBlob = {data: this.arr}

  static stringToUint8Array(str: string) {
    let arr = new Uint8Array(str.length);
    for (let i = 0, j = str.length; i < j; ++i) {
      arr[i] = str.charCodeAt(i);
    }
    return arr;
  }

  static Uint8ArrayToString(fileData:Uint8Array) {
    let dataString = '';
    for (let i = 0; i < fileData.length; i++) {
      dataString += String.fromCharCode(fileData[i]);
    }
    return dataString;
  }

  // bytesToUint8Array(arr: Array<number>): Uint8Array {
  //   let arr1 = new Uint8Array(arr.length)
  //   for (let i = 0; i < arr.length; i++) {
  //     arr1[i] = arr[i]
  //   }
  //   return arr1
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

  // byteToString(byte: Array<number>): string {
  //   let str: string = '', _arr: Array<number> = byte;
  //   for (let i = 0; i < _arr.length; i++) {
  //     let one = _arr[i].toString(2),
  //       v = one.match(/^1+?(?=0)/);
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
    let buffer = new ArrayBuffer(20);
    let result = new Uint8Array(buffer);
    // result = textEncoder.encodeInto("\uD800¥¥");
    result = textEncoder.encodeInto(str)
    // console.log("encode result = " + result.toString())
    return result
  }

  // 公钥加密
  static async encryptByPub(message: string, pubkey: string): Promise<cryptoFramework.DataBlob> {
    console.log(message)
    console.log(pubkey)
    const base = new util.Base64Helper
    // Create an AsyKeyGenerator instance.
    // let rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA1024|PRIMES_2");
    // Create a Cipher instance.
    let cipher = cryptoFramework.createCipher("RSA1024|PKCS1");

    // let privateKey = "MIICWgIBAAKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQABAn8GNTdnSDdWzitNVTRsxduVPpciQbzKETSgMfRZ8P25KEG2Jug8XIJxw2sfyitncvjjFOLK2CoHtrF1Xtt1CAUV3j3OMcNnbAUgMuhNHpnSDCLKMN5f/DcfgxqMlPDJRzFutX6dWlxFbCZor6fxZ0yJZJvEqo3DF3PNmY9csw0RAkEAoS/tCk77BjdOlLo8I69z/C6ry3jGesxsS7BUaPumCArLrcWMDnCtwCt9QBWzIvy5zxxYmU4obBWrNGhjbIthMwJBAOd2tDv5JGNnwj9pFIK4G7UgikGte5qm8Voqbft8i5puexNwcbYYAriBzWDMOVHf891KWAcqV0w6PP5aUoq4h0kCQD2cLgSUr8pudXDPxpD1TWYFCNFbNrJVVMeRfJIsLghA6B1htukGFMOxW8yU/sXOx87sTMk8YKL/nVMI24fvtpUCQQDLnnRdkgX94MhUKied+0J8q5yUvH3RBe2qSUspgl35RBnHdxLBgwvZrm6zKdV+/km0sXMREqFrcIw5odGdMUnpAkA65O6hyyZ4aH50kS3x7cfbRKPFRjGl6ugA6mtoubhnWrV+Z0lyBXLdnd+hhd2PacpdyK7IZbymsuBge6rEHae7"
    // let publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQAB"

    let publicKey1: cryptoFramework.DataBlob = {data: base.decodeSync(pubkey)}
    let keyPair = await RSA.rsaGenerator.convertKey(publicKey1, null)
    await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, keyPair.pubKey, null)
    let input: cryptoFramework.DataBlob = { data: RSA.textEncodeByUtf8(message)};
    let globalCipherData = await cipher.doFinal(input)
    console.info(`doFinal cipher success.`);
    console.log("rsa encrypt globalCipherData:" + globalCipherData.data.toString())
    return globalCipherData
  }

  // 私钥解密
  static async decryptByPri(message: cryptoFramework.DataBlob, prikey: string): Promise<string> {
    console.log(message.data.toString())
    console.log(prikey)
    const base = new util.Base64Helper
    // Create an AsyKeyGenerator instance.
    // let rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA1024|PRIMES_2")
    // Create a Cipher instance.
    let cipher = cryptoFramework.createCipher("RSA1024|PKCS1")

    let privateKey1: cryptoFramework.DataBlob = {data: base.decodeSync(prikey)}
    let keyPair = await RSA.rsaGenerator.convertKey(null, privateKey1)
    await cipher.init(cryptoFramework.CryptoMode.DECRYPT_MODE, keyPair.priKey, null)
    let plainText: cryptoFramework.DataBlob = message
    console.log(`plainText:${plainText.data.toString()}`)
    let globalCipherData = await cipher.doFinal(plainText)
    console.info(`rsa doFinal cipher success.`);
    console.log("rsa decrypt globalCipherData:" + globalCipherData.data.toString())
    let decryptStr = RSA.textDecodeByUtf8(globalCipherData.data)
    console.log("rsa decryptStr:" + decryptStr)
    return decryptStr
  }

  // 私钥加密
  static async encryptByPri(message: string, prikey: string): Promise<cryptoFramework.DataBlob> {
    console.log(message)
    console.log(prikey)
    const base = new util.Base64Helper
    // Create an AsyKeyGenerator instance.
    // let rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA1024|PRIMES_2");
    // Create a Cipher instance.
    let cipher = cryptoFramework.createCipher("RSA1024|PKCS1")

    let privateKey1: cryptoFramework.DataBlob = {data: base.decodeSync(prikey)}
    let keyPair = await RSA.rsaGenerator.convertKey(null, privateKey1)
    await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, keyPair.priKey, null)
    let input: cryptoFramework.DataBlob = {data: RSA.textEncodeByUtf8(message)};
    let globalCipherData = await cipher.doFinal(input)
    console.info(`doFinal cipher success1.`);
    console.log("rsa encrypt globalCipherData1:" + globalCipherData.data.toString())
    return globalCipherData
  }

  static async decryptByPub(message: cryptoFramework.DataBlob, pubkey: string): Promise<string> {
    console.log(message.data.toString())
    console.log(pubkey)
    const base = new util.Base64Helper
    // Create an AsyKeyGenerator instance.
    // let rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA1024|PRIMES_2")
    // Create a Cipher instance.
    let cipher = cryptoFramework.createCipher("RSA1024|PKCS1")

    let publicKey1: cryptoFramework.DataBlob = {data: base.decodeSync(pubkey)}
    let keyPair = await RSA.rsaGenerator.convertKey(publicKey1, null)
    await cipher.init(cryptoFramework.CryptoMode.DECRYPT_MODE, keyPair.pubKey, null)
    let plainText: cryptoFramework.DataBlob = message
    console.log(`plainText:${plainText.data.toString()}`)
    let globalCipherData = await cipher.doFinal(plainText)
    console.info(`doFinal cipher success1.`);
    console.log("rsa decrypt globalCipherData1:" + globalCipherData.data.toString())
    let decryptStr = RSA.textDecodeByUtf8(globalCipherData.data)
    console.log("rsa decryptStr1:" + decryptStr)
    return decryptStr
  }

  // Encrypt the message in promise mode.
  encryptMessagePromise(message: string) {
    console.log(message)
    const base = new util.Base64Helper
    // Create an AsyKeyGenerator instance.
    // let rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA1024|PRIMES_2");
    // Create a Cipher instance.
    let cipher = cryptoFramework.createCipher("RSA1024|PKCS1");
    // Generate an asymmetric key pair using the AsyKeyGenerator instance.
    // let keyGenPromise = rsaGenerator.generateKeyPair();

    let privateKey = "MIICWgIBAAKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQABAn8GNTdnSDdWzitNVTRsxduVPpciQbzKETSgMfRZ8P25KEG2Jug8XIJxw2sfyitncvjjFOLK2CoHtrF1Xtt1CAUV3j3OMcNnbAUgMuhNHpnSDCLKMN5f/DcfgxqMlPDJRzFutX6dWlxFbCZor6fxZ0yJZJvEqo3DF3PNmY9csw0RAkEAoS/tCk77BjdOlLo8I69z/C6ry3jGesxsS7BUaPumCArLrcWMDnCtwCt9QBWzIvy5zxxYmU4obBWrNGhjbIthMwJBAOd2tDv5JGNnwj9pFIK4G7UgikGte5qm8Voqbft8i5puexNwcbYYAriBzWDMOVHf891KWAcqV0w6PP5aUoq4h0kCQD2cLgSUr8pudXDPxpD1TWYFCNFbNrJVVMeRfJIsLghA6B1htukGFMOxW8yU/sXOx87sTMk8YKL/nVMI24fvtpUCQQDLnnRdkgX94MhUKied+0J8q5yUvH3RBe2qSUspgl35RBnHdxLBgwvZrm6zKdV+/km0sXMREqFrcIw5odGdMUnpAkA65O6hyyZ4aH50kS3x7cfbRKPFRjGl6ugA6mtoubhnWrV+Z0lyBXLdnd+hhd2PacpdyK7IZbymsuBge6rEHae7"
    let publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQAB"

    let publicKey1: cryptoFramework.DataBlob = {data: base.decodeSync(publicKey)}
    let keyGenPromise = RSA.rsaGenerator.convertKey(publicKey1, null)

    // keyGenPromise.then( keyPair => {
    //   console.info("rsa convertKey success.");
    // }).catch((error: BusinessError) => {
    //   console.error("rsa convertKey error.");
    // });

    keyGenPromise.then((rsaKeyPair: cryptoFramework.KeyPair): Promise<void> => {
      let pubKey = rsaKeyPair.pubKey;
      // Initialize the Cipher instance and use the public key to encrypt the data.
      return cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, pubKey, null);
    }).then(() => {
      // doFinal
      let input: cryptoFramework.DataBlob = { data: RSA.textEncodeByUtf8(plan) };
      return cipher.doFinal(input);
    }).then(dataBlob => {
      // Obtain the encrypted data.
      this.globalDataBlob = dataBlob
      console.info("this.globalDataBlob1: " + this.globalDataBlob.data.toString());
      console.info("EncryptOutPut is " + dataBlob.data);
      console.info("EncryptOutPut string is " + dataBlob.data.toLocaleString());
    });
  }

  decryptMessagePromise() {
    // console.log(message.data.toString())
    const base = new util.Base64Helper
    // Create an AsyKeyGenerator instance.
    // let rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA1024|PRIMES_2");
    // Create a Cipher instance.
    let cipher = cryptoFramework.createCipher("RSA1024|PKCS1");
    // Generate an asymmetric key pair using the AsyKeyGenerator instance.
    // let keyGenPromise = rsaGenerator.generateKeyPair();
    let privateKey = "MIICWgIBAAKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQABAn8GNTdnSDdWzitNVTRsxduVPpciQbzKETSgMfRZ8P25KEG2Jug8XIJxw2sfyitncvjjFOLK2CoHtrF1Xtt1CAUV3j3OMcNnbAUgMuhNHpnSDCLKMN5f/DcfgxqMlPDJRzFutX6dWlxFbCZor6fxZ0yJZJvEqo3DF3PNmY9csw0RAkEAoS/tCk77BjdOlLo8I69z/C6ry3jGesxsS7BUaPumCArLrcWMDnCtwCt9QBWzIvy5zxxYmU4obBWrNGhjbIthMwJBAOd2tDv5JGNnwj9pFIK4G7UgikGte5qm8Voqbft8i5puexNwcbYYAriBzWDMOVHf891KWAcqV0w6PP5aUoq4h0kCQD2cLgSUr8pudXDPxpD1TWYFCNFbNrJVVMeRfJIsLghA6B1htukGFMOxW8yU/sXOx87sTMk8YKL/nVMI24fvtpUCQQDLnnRdkgX94MhUKied+0J8q5yUvH3RBe2qSUspgl35RBnHdxLBgwvZrm6zKdV+/km0sXMREqFrcIw5odGdMUnpAkA65O6hyyZ4aH50kS3x7cfbRKPFRjGl6ugA6mtoubhnWrV+Z0lyBXLdnd+hhd2PacpdyK7IZbymsuBge6rEHae7"
    let publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQAB"

    let privateKey1: cryptoFramework.DataBlob = {data: base.decodeSync(privateKey)}
    let keyGenPromise = RSA.rsaGenerator.convertKey(null, privateKey1)

    // keyGenPromise.then( keyPair => {
    //   console.info("rsa convertKey success.");
    // }).catch((error: BusinessError) => {
    //   console.error("rsa convertKey error.");
    // });

    keyGenPromise.then((rsaKeyPair: cryptoFramework.KeyPair): Promise<void> => {
      let prikey = rsaKeyPair.priKey;
      // Initialize the Cipher instance and use the public key to encrypt the data.
      return cipher.init(cryptoFramework.CryptoMode.DECRYPT_MODE, prikey, null);
    }).then(() => {
      // doFinal
      // let input: cryptoFramework.DataBlob = message
      console.info("this.globalDataBlob2: " + this.globalDataBlob.data.toString());
      let input: cryptoFramework.DataBlob = this.globalDataBlob
      return cipher.doFinal(input);
    }).then(dataBlob => {
      // Obtain the encrypted data.
      console.info("DecryptOutPut is " + dataBlob.data);
      console.info("DecryptOutPut string is " + dataBlob.data.toLocaleString());
    });

  }

  // Encrypt the message in callback mode.
  encryptMessageCallback() {
    // Create an AsyKeyGenerator instance.
    let rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA1024|PRIMES_2");
    // Create a Cipher instance.
    let cipher = cryptoFramework.createCipher("RSA1024|PKCS1");
    // Generate an asymmetric key pair using the AsyKeyGenerator instance.
    rsaGenerator.generateKeyPair((err, keyPair) => {
      let pubKey = keyPair.pubKey;
      // Initialize the Cipher instance and use the public key to encrypt the data.
      cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, pubKey, null, (err, data) => {
        let input: cryptoFramework.DataBlob = { data: RSA.stringToUint8Array(plan) };
        // doFinal
        cipher.doFinal(input, (err, data) => {
          // Obtain the encrypted data.
          console.info("EncryptOutPut is " + data.data);
        })
      })
    })
  }

  // Encrypt and decrypt the message in promise mode.
  decryptMessagePromise1(message: string) {
    console.log(message)
    const base = new util.Base64Helper
    // Create an AsyKeyGenerator instance.
    let rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA1024|PRIMES_2");
    // Create a Cipher instance for encryption.
    let cipher = cryptoFramework.createCipher("RSA1024|PKCS1");
    // Create a Cipher instance for decryption.
    let decoder = cryptoFramework.createCipher("RSA1024|PKCS1");
    // Generate an asymmetric key pair using the AsyKeyGenerator instance.
    // let keyGenPromise = rsaGenerator.generateKeyPair();

    // hex
    // let privateKey = "MIICWwIBAAKBgQCPvD/AiJaNsmQxqH7nyRqq7v5JoMeyveYWYh16aVHhtlyMArxQhlcCtMDTcV3ydRMng7eIg9Sz6YE9RakMjOQ15NcS3IbtMPyqcVibc4GEojgieFuiKYLBtO87ZfVEzrevlkifaCXNcEq7j0pxTlCrVlTyFDSQoM/v0lNJFHeUfwIDAQABAoGAI+q2AY4AFQNdTx1cLN5PaCRVbZ+cFzmlu7UjyZl0yRKxOJlcZkDTkE0LnCqJf9MqiKa834OVzKlOTrnP/t9cDQ0NLgDymRg3PPxAss2AIn6sKc2f14tJ5W+WLM8UdEMetKPrMW7G82hRb/zhiZxaoYUp9PHJzAtuQzbKySyugUECQQCqlZdMTtqubkmc3SJyD4Pthzkbs4dBiQW9kJMsWwFGAAVk4sf/RoLwcVioANrasE1SHLF+6bH8YmA3Q+FgiSLBAkEA17UC4ZEyyRVP1ob6IcgKzqVSGcev7urJUQC3omN9vz4u6nQxr5IKtUxFJIappE8a/y/BJ2EF6B5Du/NCibTHPwJABeM/45xdI+QemlFvnOw4K3ydVf1uT67BCffxfHhvpNDfXsoNCRyP7GidHL9azm2DXbAr2CuMvx9OHtoy7zgMgQJBAKcYwbKbGAxNRhuZVAr3O+f4iTEPT2p01p65P4e8Kp0LPqzAdfzb1Q+8lZNF/gQag39LLwWiU0EMsMvYFaM3N2ECP259K1TDTY7bPGL2keIpi+ZFHEUVj3Zcyvq5VzYiNtbGhrGYaV4boHmnqblczgUc1hmtde1eKoo0To+IskUc+A=="
    // let publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCPvD/AiJaNsmQxqH7nyRqq7v5JoMeyveYWYh16aVHhtlyMArxQhlcCtMDTcV3ydRMng7eIg9Sz6YE9RakMjOQ15NcS3IbtMPyqcVibc4GEojgieFuiKYLBtO87ZfVEzrevlkifaCXNcEq7j0pxTlCrVlTyFDSQoM/v0lNJFHeUfwIDAQAB"

    // base64
    let privateKey = "MIICWgIBAAKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQABAn8GNTdnSDdWzitNVTRsxduVPpciQbzKETSgMfRZ8P25KEG2Jug8XIJxw2sfyitncvjjFOLK2CoHtrF1Xtt1CAUV3j3OMcNnbAUgMuhNHpnSDCLKMN5f/DcfgxqMlPDJRzFutX6dWlxFbCZor6fxZ0yJZJvEqo3DF3PNmY9csw0RAkEAoS/tCk77BjdOlLo8I69z/C6ry3jGesxsS7BUaPumCArLrcWMDnCtwCt9QBWzIvy5zxxYmU4obBWrNGhjbIthMwJBAOd2tDv5JGNnwj9pFIK4G7UgikGte5qm8Voqbft8i5puexNwcbYYAriBzWDMOVHf891KWAcqV0w6PP5aUoq4h0kCQD2cLgSUr8pudXDPxpD1TWYFCNFbNrJVVMeRfJIsLghA6B1htukGFMOxW8yU/sXOx87sTMk8YKL/nVMI24fvtpUCQQDLnnRdkgX94MhUKied+0J8q5yUvH3RBe2qSUspgl35RBnHdxLBgwvZrm6zKdV+/km0sXMREqFrcIw5odGdMUnpAkA65O6hyyZ4aH50kS3x7cfbRKPFRjGl6ugA6mtoubhnWrV+Z0lyBXLdnd+hhd2PacpdyK7IZbymsuBge6rEHae7"
    let publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQAB"

    // stringToUint8Array
    // let publicKey1: cryptoFramework.DataBlob = {data: this.stringToUint8Array(publicKey)}
    // let privateKey1: cryptoFramework.DataBlob = {data: this.stringToUint8Array(privateKey)}

    // utf-8
    // let publicKey1: cryptoFramework.DataBlob = {data: this.bytesToUint8Array(this.stringToBytes(publicKey))}
    // let privateKey1: cryptoFramework.DataBlob = {data: this.bytesToUint8Array(this.stringToBytes(privateKey))}

    // base64 decode
    let publicKey1: cryptoFramework.DataBlob = {data: base.decodeSync(publicKey)}
    let privateKey1: cryptoFramework.DataBlob = {data: base.decodeSync(privateKey)}

    let keyGenPromise = rsaGenerator.convertKey(publicKey1, privateKey1)
    // keyGenPromise.then( keyPair => {
    //   console.info("rsa convertKey success.");
    // }).catch((error: BusinessError) => {
    //   console.error("rsa convertKey error.");
    // });

    //
    let keyPair: cryptoFramework.KeyPair;
    let cipherDataBlob: cryptoFramework.DataBlob;
    let input: cryptoFramework.DataBlob = {data: RSA.textEncodeByUtf8(message)};
    // console.log(input.data.toString());
    // console.log(`plan:${this.Uint8ArrayToString(input.data)}`);
    keyGenPromise.then((rsaKeyPair: cryptoFramework.KeyPair): Promise<void> => {
      console.info("convertKey success.");
      keyPair = rsaKeyPair;
      // Initialize the Cipher instance and use the public key to encrypt the message.
      return cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, keyPair.pubKey, null);
    })
      .then(() => {
        // Call doFinal() to encrypt data.
        return cipher.doFinal(input);
      })
      .then((dataBlob: cryptoFramework.DataBlob): Promise<void> => {
        // Obtain the encrypted information and use it as the input parameter for decryption.
        console.info("EncryptOutPut is " + dataBlob.data);
        AlertDialog.show({ message: "output" + dataBlob.data });
        cipherDataBlob = dataBlob;
        // Initialize the Cipher instance and use the private key to decrypt the message.
        return decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, keyPair.priKey, null);
      })
      .then(() => {
        // Call doFinal() to decrypt the message.
        return decoder.doFinal(cipherDataBlob);
      })
      .then(decodeData => {
        // Check whether the decrypted data is consistent with the original data.
        console.log(`DecryptOutPut is : ${RSA.textDecodeByUtf8(decodeData.data)}`)
        AlertDialog.show({message: RSA.textDecodeByUtf8(decodeData.data)})
        if (decodeData.data.toString() === input.data.toString()) {
          AlertDialog.show({ message: "decrypt success" });
          return;
        }
        AlertDialog.show({ message: "decrypt fail" });
      });

  }

  // 私钥加密，公钥解密
  decryptMessagePromise3(message: string) {
    console.log(message)
    const base = new util.Base64Helper
    // Create an AsyKeyGenerator instance.
    let rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA1024|PRIMES_2");
    // Create a Cipher instance for encryption.
    let cipher = cryptoFramework.createCipher("RSA1024|PKCS1");
    // Create a Cipher instance for decryption.
    let decoder = cryptoFramework.createCipher("RSA1024|PKCS1");

    // base64
    let privateKey = "MIICWgIBAAKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQABAn8GNTdnSDdWzitNVTRsxduVPpciQbzKETSgMfRZ8P25KEG2Jug8XIJxw2sfyitncvjjFOLK2CoHtrF1Xtt1CAUV3j3OMcNnbAUgMuhNHpnSDCLKMN5f/DcfgxqMlPDJRzFutX6dWlxFbCZor6fxZ0yJZJvEqo3DF3PNmY9csw0RAkEAoS/tCk77BjdOlLo8I69z/C6ry3jGesxsS7BUaPumCArLrcWMDnCtwCt9QBWzIvy5zxxYmU4obBWrNGhjbIthMwJBAOd2tDv5JGNnwj9pFIK4G7UgikGte5qm8Voqbft8i5puexNwcbYYAriBzWDMOVHf891KWAcqV0w6PP5aUoq4h0kCQD2cLgSUr8pudXDPxpD1TWYFCNFbNrJVVMeRfJIsLghA6B1htukGFMOxW8yU/sXOx87sTMk8YKL/nVMI24fvtpUCQQDLnnRdkgX94MhUKied+0J8q5yUvH3RBe2qSUspgl35RBnHdxLBgwvZrm6zKdV+/km0sXMREqFrcIw5odGdMUnpAkA65O6hyyZ4aH50kS3x7cfbRKPFRjGl6ugA6mtoubhnWrV+Z0lyBXLdnd+hhd2PacpdyK7IZbymsuBge6rEHae7"
    let publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQAB"

    // base64 decode
    let publicKey1: cryptoFramework.DataBlob = {data: base.decodeSync(publicKey)}
    let privateKey1: cryptoFramework.DataBlob = {data: base.decodeSync(privateKey)}

    let keyGenPromise = rsaGenerator.convertKey(publicKey1, privateKey1)

    //
    let keyPair: cryptoFramework.KeyPair;
    let cipherDataBlob: cryptoFramework.DataBlob;
    let input: cryptoFramework.DataBlob = {data: RSA.textEncodeByUtf8(message)};
    // console.log(input.data.toString());
    // console.log(`plan:${this.Uint8ArrayToString(input.data)}`);
    keyGenPromise.then((rsaKeyPair: cryptoFramework.KeyPair): Promise<void> => {
      console.info("convertKey success.");
      keyPair = rsaKeyPair;
      // Initialize the Cipher instance and use the public key to encrypt the message.
      return cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, keyPair.priKey, null);
    })
      .then(() => {
        console.log("cipher.init success")
        // Call doFinal() to encrypt data.
        return cipher.doFinal(input);
      })
      .then((dataBlob: cryptoFramework.DataBlob): Promise<void> => {
        // Obtain the encrypted information and use it as the input parameter for decryption.
        console.info("EncryptOutPut is " + dataBlob.data);
        AlertDialog.show({ message: "output" + dataBlob.data });
        cipherDataBlob = dataBlob;
        // Initialize the Cipher instance and use the private key to decrypt the message.
        return decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, keyPair.pubKey, null);
      })

      .then(() => {
        // Call doFinal() to decrypt the message.
        return decoder.doFinal(cipherDataBlob);
      })
      .then(decodeData => {
        // Check whether the decrypted data is consistent with the original data.
        console.log(`DecryptOutPut is : ${RSA.textDecodeByUtf8(decodeData.data)}`)
        AlertDialog.show({message: RSA.textDecodeByUtf8(decodeData.data)})
        if (decodeData.data.toString() === input.data.toString()) {
          AlertDialog.show({ message: "decrypt success" });
          return;
        }
        AlertDialog.show({ message: "decrypt fail" });
      })
      .catch((err: BusinessError) => {
        console.log(JSON.stringify(err))
      })

  }

  // Encrypt and decrypt the message in promise mode.
  decryptMessagePromise2(message: string) {
    console.log(message)
    const base = new util.Base64Helper
    // Create an AsyKeyGenerator instance.
    let rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA1024|PRIMES_2");
    // Create a Cipher instance for encryption.
    let cipher = cryptoFramework.createCipher("RSA1024|PKCS1");
    // Create a Cipher instance for decryption.
    let decoder = cryptoFramework.createCipher("RSA1024|PKCS1");
    // Generate an asymmetric key pair using the AsyKeyGenerator instance.
    // let keyGenPromise = rsaGenerator.generateKeyPair();

    // hex
    // let privateKey = "MIICWwIBAAKBgQCPvD/AiJaNsmQxqH7nyRqq7v5JoMeyveYWYh16aVHhtlyMArxQhlcCtMDTcV3ydRMng7eIg9Sz6YE9RakMjOQ15NcS3IbtMPyqcVibc4GEojgieFuiKYLBtO87ZfVEzrevlkifaCXNcEq7j0pxTlCrVlTyFDSQoM/v0lNJFHeUfwIDAQABAoGAI+q2AY4AFQNdTx1cLN5PaCRVbZ+cFzmlu7UjyZl0yRKxOJlcZkDTkE0LnCqJf9MqiKa834OVzKlOTrnP/t9cDQ0NLgDymRg3PPxAss2AIn6sKc2f14tJ5W+WLM8UdEMetKPrMW7G82hRb/zhiZxaoYUp9PHJzAtuQzbKySyugUECQQCqlZdMTtqubkmc3SJyD4Pthzkbs4dBiQW9kJMsWwFGAAVk4sf/RoLwcVioANrasE1SHLF+6bH8YmA3Q+FgiSLBAkEA17UC4ZEyyRVP1ob6IcgKzqVSGcev7urJUQC3omN9vz4u6nQxr5IKtUxFJIappE8a/y/BJ2EF6B5Du/NCibTHPwJABeM/45xdI+QemlFvnOw4K3ydVf1uT67BCffxfHhvpNDfXsoNCRyP7GidHL9azm2DXbAr2CuMvx9OHtoy7zgMgQJBAKcYwbKbGAxNRhuZVAr3O+f4iTEPT2p01p65P4e8Kp0LPqzAdfzb1Q+8lZNF/gQag39LLwWiU0EMsMvYFaM3N2ECP259K1TDTY7bPGL2keIpi+ZFHEUVj3Zcyvq5VzYiNtbGhrGYaV4boHmnqblczgUc1hmtde1eKoo0To+IskUc+A=="
    // let publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCPvD/AiJaNsmQxqH7nyRqq7v5JoMeyveYWYh16aVHhtlyMArxQhlcCtMDTcV3ydRMng7eIg9Sz6YE9RakMjOQ15NcS3IbtMPyqcVibc4GEojgieFuiKYLBtO87ZfVEzrevlkifaCXNcEq7j0pxTlCrVlTyFDSQoM/v0lNJFHeUfwIDAQAB"

    // base64
    let privateKey = "MIICWgIBAAKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQABAn8GNTdnSDdWzitNVTRsxduVPpciQbzKETSgMfRZ8P25KEG2Jug8XIJxw2sfyitncvjjFOLK2CoHtrF1Xtt1CAUV3j3OMcNnbAUgMuhNHpnSDCLKMN5f/DcfgxqMlPDJRzFutX6dWlxFbCZor6fxZ0yJZJvEqo3DF3PNmY9csw0RAkEAoS/tCk77BjdOlLo8I69z/C6ry3jGesxsS7BUaPumCArLrcWMDnCtwCt9QBWzIvy5zxxYmU4obBWrNGhjbIthMwJBAOd2tDv5JGNnwj9pFIK4G7UgikGte5qm8Voqbft8i5puexNwcbYYAriBzWDMOVHf891KWAcqV0w6PP5aUoq4h0kCQD2cLgSUr8pudXDPxpD1TWYFCNFbNrJVVMeRfJIsLghA6B1htukGFMOxW8yU/sXOx87sTMk8YKL/nVMI24fvtpUCQQDLnnRdkgX94MhUKied+0J8q5yUvH3RBe2qSUspgl35RBnHdxLBgwvZrm6zKdV+/km0sXMREqFrcIw5odGdMUnpAkA65O6hyyZ4aH50kS3x7cfbRKPFRjGl6ugA6mtoubhnWrV+Z0lyBXLdnd+hhd2PacpdyK7IZbymsuBge6rEHae7"
    let publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQAB"

    // stringToUint8Array
    // let publicKey1: cryptoFramework.DataBlob = {data: this.stringToUint8Array(publicKey)}
    // let privateKey1: cryptoFramework.DataBlob = {data: this.stringToUint8Array(privateKey)}

    // utf-8
    // let publicKey1: cryptoFramework.DataBlob = {data: this.bytesToUint8Array(this.stringToBytes(publicKey))}
    // let privateKey1: cryptoFramework.DataBlob = {data: this.bytesToUint8Array(this.stringToBytes(privateKey))}

    // base64 decode
    let publicKey1: cryptoFramework.DataBlob = {data: base.decodeSync(publicKey)}
    let privateKey1: cryptoFramework.DataBlob = {data: base.decodeSync(privateKey)}

    let keyGenPromise = rsaGenerator.convertKey(publicKey1, privateKey1)
    // keyGenPromise.then( keyPair => {
    //   console.info("rsa convertKey success.");
    // }).catch((error: BusinessError) => {
    //   console.error("rsa convertKey error.");
    // })

    //
    let keyPair: cryptoFramework.KeyPair;
    let cipherDataBlob: cryptoFramework.DataBlob;
    let input: cryptoFramework.DataBlob = {data: RSA.textEncodeByUtf8(message)};
    // console.log(input.data.toString());
    // console.log(`plan:${this.Uint8ArrayToString(input.data)}`);
    keyGenPromise.then((rsaKeyPair: cryptoFramework.KeyPair): Promise<void> => {
      console.info("convertKey success.");
      keyPair = rsaKeyPair;
      // Initialize the Cipher instance and use the public key to encrypt the message.
      return cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, keyPair.pubKey, null);
    })
      .catch((error: BusinessError) => {
      console.error("cipher.init error.");
    })
      .then(() => {
        console.info("cipher.init success.");
        // Call doFinal() to encrypt data.
        return cipher.doFinal(input);
      })
      .then((dataBlob: cryptoFramework.DataBlob): Promise<void> => {
        // Obtain the encrypted information and use it as the input parameter for decryption.
        console.info("EncryptOutPut is " + dataBlob.data);
        AlertDialog.show({ message: "output" + dataBlob.data });
        cipherDataBlob = dataBlob;
        // Initialize the Cipher instance and use the private key to decrypt the message.
        return decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, keyPair.priKey, null);
      })
      .then(() => {
        // Call doFinal() to decrypt the message.
        return decoder.doFinal(cipherDataBlob);
      })
      .then(decodeData => {
        // Check whether the decrypted data is consistent with the original data.
        console.log(`DecryptOutPut is : ${RSA.textDecodeByUtf8(decodeData.data)}`)
        AlertDialog.show({message: RSA.textDecodeByUtf8(decodeData.data)})
        if (decodeData.data.toString() === input.data.toString()) {
          AlertDialog.show({ message: "decrypt success" });
          return;
        }
        AlertDialog.show({ message: "decrypt fail" });
      });

  }

  // Encrypt and decrypt the message in callback mode.
  // decryptMessageCallback() {
  //   // Create an AsyKeyGenerator instance.
  //   let rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA1024|PRIMES_2");
  //   // Create a Cipher instance for encryption.
  //   let cipher = cryptoFramework.createCipher("RSA1024|PKCS1");
  //   // Create a Cipher instance for decryption.
  //   let decoder = cryptoFramework.createCipher("RSA1024|PKCS1");
  //   let plainText = "this is cipher text";
  //   let input: cryptoFramework.DataBlob = { data: this.stringToUint8Array(plainText) };
  //   // Generate an asymmetric key pair using the AsyKeyGenerator instance.
  //   rsaGenerator.generateKeyPair((err, newKeyPair) => {
  //     let keyPair = newKeyPair;
  //     // Initialize the Cipher instance and use the public key to encrypt the message.
  //     cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, keyPair.pubKey, null, (err, data) => {
  //       // Call doFinal() to encrypt the message.
  //       cipher.doFinal(input, (err, data) => {
  //         // Obtain the encrypted information and use it as the input parameter for decryption.
  //         AlertDialog.show({ message: "EncryptOutPut is " + data.data });
  //         let cipherData = data;
  //         // Initialize the Cipher instance and use the private key to decrypt the message.
  //         decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, keyPair.priKey, null, (err, data) => {
  //           // Call doFinal() to decrypt the message.
  //           decoder.doFinal(cipherData, (err, data) => {
  //             // Check whether the decrypted data is consistent with the original data.
  //             if (input.data.toString() === data.data.toString()) {
  //               AlertDialog.show({ message: "decrype success" });
  //               return;
  //             }
  //             AlertDialog.show({ message: "decrype fail" });
  //           });
  //         });
  //       });
  //     });
  //   });
  // }

}