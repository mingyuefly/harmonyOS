import cryptoFramework from '@ohos.security.cryptoFramework';
import { BusinessError } from '@ohos.base';
import util from '@ohos.util';

let globalKeyPair: cryptoFramework.KeyPair;
let signMessageBlob: cryptoFramework.DataBlob;
let plan1 = "This is Sign test plan1";
let plan2 = "This is Sign test plan1";

export class RSASign {

  // 可理解的字符串转成字节流
  static stringToUint8Array(str: string) {
    let arr = new Uint8Array(str.length);
    for (let i = 0, j = str.length; i < j; ++i) {
      arr[i] = str.charCodeAt(i);
    }
    return arr;
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

  static async sign(message: string, prikey: string): Promise<cryptoFramework.DataBlob> {
    console.log(message)
    let input: cryptoFramework.DataBlob = { data: RSASign.textEncodeByUtf8(message) }
    let rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA2048|PRIMES_2")
    let signer = cryptoFramework.createSign("RSA2048|PKCS1|MD5")

    const base = new util.Base64Helper
    let privateKey1: cryptoFramework.DataBlob = {data: base.decodeSync(prikey)}
    let keyPair = await rsaGenerator.convertKey(null, privateKey1)

    await signer.init(keyPair.priKey)
    await signer.update(input)
    let signData = await signer.sign(input)
    return signData
  }

  static async verify(message: string, signString: cryptoFramework.DataBlob, pubkey: string): Promise<boolean> {
    let input: cryptoFramework.DataBlob = { data: RSASign.textEncodeByUtf8(message) }
    let rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA2048|PRIMES_2")
    let verifyer = cryptoFramework.createVerify("RSA2048|PKCS1|MD5")

    const base = new util.Base64Helper
    let publicKey1: cryptoFramework.DataBlob = {data: base.decodeSync(pubkey)}
    let keyPair = await rsaGenerator.convertKey(publicKey1, null)
    await verifyer.init(keyPair.pubKey)
    await verifyer.update(input)
    let success = await verifyer.verify(input, signString)
    return success
  }

  signMessagePromise1(message: string) {
    // let input1: cryptoFramework.DataBlob = { data: this.stringToUint8Array(plan1) };
    // let input2: cryptoFramework.DataBlob = { data: this.stringToUint8Array(plan2) };
    let input1: cryptoFramework.DataBlob = { data: RSASign.textEncodeByUtf8(message) };
    let input2: cryptoFramework.DataBlob = { data: RSASign.textEncodeByUtf8(message) };

    let rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA1024|PRIMES_2");
    let signer = cryptoFramework.createSign("RSA1024|PKCS1|SHA256"); // From API version 10, a Sign instance can be created by specifying a string parameter defining the key specifications.
    // let keyGenPromise = rsaGenerator.generateKeyPair();
    // let verifyer = cryptoFramework.createVerify("RSA1024|PKCS1|SHA256")

    const base = new util.Base64Helper

    // base64
    let privateKey = "MIICWgIBAAKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQABAn8GNTdnSDdWzitNVTRsxduVPpciQbzKETSgMfRZ8P25KEG2Jug8XIJxw2sfyitncvjjFOLK2CoHtrF1Xtt1CAUV3j3OMcNnbAUgMuhNHpnSDCLKMN5f/DcfgxqMlPDJRzFutX6dWlxFbCZor6fxZ0yJZJvEqo3DF3PNmY9csw0RAkEAoS/tCk77BjdOlLo8I69z/C6ry3jGesxsS7BUaPumCArLrcWMDnCtwCt9QBWzIvy5zxxYmU4obBWrNGhjbIthMwJBAOd2tDv5JGNnwj9pFIK4G7UgikGte5qm8Voqbft8i5puexNwcbYYAriBzWDMOVHf891KWAcqV0w6PP5aUoq4h0kCQD2cLgSUr8pudXDPxpD1TWYFCNFbNrJVVMeRfJIsLghA6B1htukGFMOxW8yU/sXOx87sTMk8YKL/nVMI24fvtpUCQQDLnnRdkgX94MhUKied+0J8q5yUvH3RBe2qSUspgl35RBnHdxLBgwvZrm6zKdV+/km0sXMREqFrcIw5odGdMUnpAkA65O6hyyZ4aH50kS3x7cfbRKPFRjGl6ugA6mtoubhnWrV+Z0lyBXLdnd+hhd2PacpdyK7IZbymsuBge6rEHae7"
    // let publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQAB"

    // base64 decode
    // let publicKey1: cryptoFramework.DataBlob = {data: base.decodeSync(publicKey)}
    let privateKey1: cryptoFramework.DataBlob = {data: base.decodeSync(privateKey)}

    let keyGenPromise = rsaGenerator.convertKey(null, privateKey1)

    keyGenPromise.then(keyPair => {
      globalKeyPair = keyPair;
      let priKey = globalKeyPair.priKey;
      return signer.init(priKey);
    }).then(() => {
      return signer.update(input1);
    }).then(() => {
      return signer.sign(input2);
    }).then(dataBlob => {
      signMessageBlob = dataBlob;
      console.info("sign1 output is " + signMessageBlob.data);;
    })
  }

  signMessagePromise(message: string) {
    // let input1: cryptoFramework.DataBlob = { data: this.stringToUint8Array(plan1) };
    // let input2: cryptoFramework.DataBlob = { data: this.stringToUint8Array(plan2) };
    let input1: cryptoFramework.DataBlob = { data: RSASign.textEncodeByUtf8(message) };
    let input2: cryptoFramework.DataBlob = { data: RSASign.textEncodeByUtf8(message) };

    let rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA1024|PRIMES_2");
    let signer = cryptoFramework.createSign("RSA1024|PKCS1|SHA256"); // From API version 10, a Sign instance can be created by specifying a string parameter defining the key specifications.
    // let keyGenPromise = rsaGenerator.generateKeyPair();
    let verifyer = cryptoFramework.createVerify("RSA1024|PKCS1|SHA256")

    const base = new util.Base64Helper

    // base64
    let privateKey = "MIICWgIBAAKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQABAn8GNTdnSDdWzitNVTRsxduVPpciQbzKETSgMfRZ8P25KEG2Jug8XIJxw2sfyitncvjjFOLK2CoHtrF1Xtt1CAUV3j3OMcNnbAUgMuhNHpnSDCLKMN5f/DcfgxqMlPDJRzFutX6dWlxFbCZor6fxZ0yJZJvEqo3DF3PNmY9csw0RAkEAoS/tCk77BjdOlLo8I69z/C6ry3jGesxsS7BUaPumCArLrcWMDnCtwCt9QBWzIvy5zxxYmU4obBWrNGhjbIthMwJBAOd2tDv5JGNnwj9pFIK4G7UgikGte5qm8Voqbft8i5puexNwcbYYAriBzWDMOVHf891KWAcqV0w6PP5aUoq4h0kCQD2cLgSUr8pudXDPxpD1TWYFCNFbNrJVVMeRfJIsLghA6B1htukGFMOxW8yU/sXOx87sTMk8YKL/nVMI24fvtpUCQQDLnnRdkgX94MhUKied+0J8q5yUvH3RBe2qSUspgl35RBnHdxLBgwvZrm6zKdV+/km0sXMREqFrcIw5odGdMUnpAkA65O6hyyZ4aH50kS3x7cfbRKPFRjGl6ugA6mtoubhnWrV+Z0lyBXLdnd+hhd2PacpdyK7IZbymsuBge6rEHae7"
    let publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQAB"

    // base64 decode
    let publicKey1: cryptoFramework.DataBlob = {data: base.decodeSync(publicKey)}
    let privateKey1: cryptoFramework.DataBlob = {data: base.decodeSync(privateKey)}

    let keyGenPromise = rsaGenerator.convertKey(publicKey1, privateKey1)

    keyGenPromise.then(keyPair => {
      globalKeyPair = keyPair;
      let priKey = globalKeyPair.priKey;
      return signer.init(priKey);
    }).then(() => {
      return signer.update(input1);
    }).then(() => {
      return signer.sign(input2);
    }).then(dataBlob => {
      signMessageBlob = dataBlob;
      console.info("sign output is " + signMessageBlob.data);;
      let pubKey = globalKeyPair.pubKey;
      return verifyer.init(pubKey);
    }).then(() => {
      return verifyer.update(input1);
    }).then(() => {
      return verifyer.verify(input2, signMessageBlob);
    }).then((res: boolean) => {
      console.log("Verify result is " + res);
    }).catch((err: BusinessError) => {
      console.log(JSON.stringify(err))
    })
  }

  // Call verify() after sign() is called.
  verifyMessagePromise() {
    let input1: cryptoFramework.DataBlob = { data: RSASign.stringToUint8Array(plan1) };
    let input2: cryptoFramework.DataBlob = { data: RSASign.stringToUint8Array(plan2) };

    let verifyer = cryptoFramework.createVerify("RSA1024|PKCS1|SHA256")

    const base = new util.Base64Helper

    // base64
    let privateKey = "MIICWgIBAAKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQABAn8GNTdnSDdWzitNVTRsxduVPpciQbzKETSgMfRZ8P25KEG2Jug8XIJxw2sfyitncvjjFOLK2CoHtrF1Xtt1CAUV3j3OMcNnbAUgMuhNHpnSDCLKMN5f/DcfgxqMlPDJRzFutX6dWlxFbCZor6fxZ0yJZJvEqo3DF3PNmY9csw0RAkEAoS/tCk77BjdOlLo8I69z/C6ry3jGesxsS7BUaPumCArLrcWMDnCtwCt9QBWzIvy5zxxYmU4obBWrNGhjbIthMwJBAOd2tDv5JGNnwj9pFIK4G7UgikGte5qm8Voqbft8i5puexNwcbYYAriBzWDMOVHf891KWAcqV0w6PP5aUoq4h0kCQD2cLgSUr8pudXDPxpD1TWYFCNFbNrJVVMeRfJIsLghA6B1htukGFMOxW8yU/sXOx87sTMk8YKL/nVMI24fvtpUCQQDLnnRdkgX94MhUKied+0J8q5yUvH3RBe2qSUspgl35RBnHdxLBgwvZrm6zKdV+/km0sXMREqFrcIw5odGdMUnpAkA65O6hyyZ4aH50kS3x7cfbRKPFRjGl6ugA6mtoubhnWrV+Z0lyBXLdnd+hhd2PacpdyK7IZbymsuBge6rEHae7"
    let publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQAB"

    // base64 decode
    let publicKey1: cryptoFramework.DataBlob = {data: base.decodeSync(publicKey)}
    let privateKey1: cryptoFramework.DataBlob = {data: base.decodeSync(privateKey)}

    let rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA1024|PRIMES_2");
    let keyGenPromise = rsaGenerator.convertKey(publicKey1, privateKey1)

    keyGenPromise.then(keyPair => {
      globalKeyPair = keyPair;
      let pubKey = globalKeyPair.pubKey;
      return verifyer.init(pubKey);
    }).then(() => {
      return verifyer.update(input1);
    }).then(() => {
      return verifyer.verify(input2, signMessageBlob);
    }).then((res: boolean) => {
      console.log("Verify result is " + res);
    }).catch((err: BusinessError) => {
        console.log(JSON.stringify(err))
    })
  }

  // signMessageCallback() {
  //   let input1: cryptoFramework.DataBlob = { data: this.stringToUint8Array(plan1) };
  //   let input2: cryptoFramework.DataBlob = { data: this.stringToUint8Array(plan2) };
  //
  //   let rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA1024|PRIMES_2");
  //   let signer = cryptoFramework.createSign("RSA1024|PKCS1|SHA256"); // From API version 10, a Sign instance can be created by specifying a string parameter defining the key specifications.
  //   rsaGenerator.generateKeyPair((err, keyPair) => {
  //     globalKeyPair = keyPair;
  //     let priKey = globalKeyPair.priKey;
  //     signer.init(priKey, err => {
  //       signer.update(input1, err => {
  //         signer.sign(input2, (err, data) => {
  //           signMessageBlob = data;
  //           console.info("sign output is " + signMessageBlob.data);
  //         });
  //       });
  //     });
  //   });
  // }

  // Call verify() after sign() is called.
  // verifyMessageCallback() {
  //   let input1: cryptoFramework.DataBlob = { data: this.stringToUint8Array(plan1) };
  //   let input2: cryptoFramework.DataBlob = { data: this.stringToUint8Array(plan2) };
  //
  //   let verifyer = cryptoFramework.createVerify("RSA1024|PKCS1|SHA256");
  //   verifyer.init(globalKeyPair.pubKey, err => {
  //     verifyer.update(input1, err => {
  //       verifyer.verify(input2, signMessageBlob, (err, data) => {
  //         console.info("verify result is " + data);
  //       });
  //     });
  //   })
  // }

}
