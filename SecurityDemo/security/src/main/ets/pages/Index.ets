import {AES} from '../securityModels/AES/AES'
import {RSA} from '../securityModels/RSA/RSA'
import {SM2} from '../securityModels/SM2/SM2'
import {MyUtils} from '../utilities/MyUtils'
import {ECC} from '../securityModels/ECC/ECC'
import {RSASign} from '../securityModels/RSA/RSASign'
import {SM4} from '../securityModels/SM4/SM4'
import cryptoFramework from '@ohos.security.cryptoFramework'
import buffer from '@ohos.buffer'

// import cryptoFramework from '@ohos.security.cryptoFramework';

async function myAsyncFunction(): Promise<void> {
  const result: string = await new Promise((resolve: Function) => {
    setTimeout(() => {
      resolve('Hello, world!1');
    }, 3000);
  });
  console.info(result); // 输出： Hello, world!
}

async function firstStep(): Promise<string> {
  const result: string = await new Promise((resolve, reject) => {
    resolve("hello world firstStep")
  });
  return result;
  // try {
  //   await new Promise((resolve, reject) => {
  //     if (1) {
  //
  //     } else {
  //       throw new Error('出错了');
  //     }
  //   });
  // } catch(e) {
  // }
  // return await('hello world firstStep');
}

async function secondStep(str: string): Promise<string> {
  const result: string = await new Promise((resolve, reject) => {
    let str1 = "hello world" + " " + str + " " + "secondStep"
    resolve(str1)
  });
  return result;

  // try {
  //   await new Promise((resolve, reject) => {
  //     throw new Error('出错了');
  //   });
  // } catch(e) {
  // }
  // return await('hello world secondStep');
}

async function thirdStep(str1: string, str2: string): Promise<string> {
  const result: string = await new Promise((resolve, reject) => {
    let str3 = "hello world" + " " + str1 + ' ' + str2 + " " + "thirdStep"
    resolve(str3)
  });
  return result;
  // try {
  //   await new Promise((resolve, reject) => {
  //     throw new Error('出错了');
  //   });
  // } catch(e) {
  // }
  // return await('hello world thirdStep');
}

async function endFunc() {
  const val1 = await firstStep();
  const val2 = await secondStep(val1);
  const val3 = await thirdStep(val1, val2);

  console.log('Final: ', val1);
  console.log('Final: ', val2);
  console.log('Final: ', val3);

  // try {
  //   const val1 = await firstStep();
  //   const val2 = await secondStep(val1);
  //   const val3 = await thirdStep(val1, val2);
  //
  //   console.log('Final: ', val3);
  // }
  // catch (err) {
  //   console.error(err);
  // }

}



// function mySyncFunction(): Promise<void> {
//   new Promise((resolve: Function) => {
//     setTimeout(() => {
//       resolve('Hello, world!3');
//     }, 3000);
//   });
//   console.info(result); // 输出： Hello, world!
// }

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  private aesModel: AES = new AES()
  private rsaModel: RSA = new RSA()
  private sm2Model: SM2 = new SM2()
  private eccModel: ECC = new ECC()
  private sm4Model: SM4 = new SM4()
  private rsaSignModel: RSASign = new RSASign()

  async aes256DecryptFunc(message: string): Promise<string> {
    // let key = AES.createAES256Key()
    // let key1: Array<number> = [52,100,101,99,86,108,66,90,101,66,98,55,108,85,103,85,49,84,53,65,48,101,51,74,68,100,87,107,51,112,50,110]
    let key1 = "djwqj238ewoc1234jlui1234yuit1256"
    let key = new Uint8Array(key1.length)
    for (let i = 0; i < key1.length; i++) {
      key[i] = key1.charCodeAt(i)
    }
    // let iv = AES.creatAESIv()
    let iv1 = "adid3456yioe9861"
    let iv = new Uint8Array(iv1.length)
    for (let i = 0; i < iv1.length; i++) {
      iv[i] = iv1.charCodeAt(i)
    }
    // let awaitEncryptStr = await AES.encrypt256(message, key, iv)
    // console.log("awaitEncryptStr: " + awaitEncryptStr.data.toString())
    let message1 = new Uint8Array(message.length)
    for (let i = 0; i < message.length; i++) {
      message1[i] = message.charCodeAt(i)
    }
    let message2: cryptoFramework.DataBlob = {data: message1}
    let awaitDecryptStr = await AES.decrypt256(message2, key, iv)
    console.log("hb awaitDecryptStr: " + awaitDecryptStr)
    return awaitDecryptStr
  }

  async aes256Func(message: string): Promise<string> {
    // let key = AES.createAES256Key()
    // let key1: Array<number> = [52,100,101,99,86,108,66,90,101,66,98,55,108,85,103,85,49,84,53,65,48,101,51,74,68,100,87,107,51,112,50,110]
    // let key = new Uint8Array(key1.length)
    // for (let i = 0; i < key1.length; i++) {
    //   key[i] = key1[i]
    // }
    // let iv = AES.creatAESIv()

    let key1 = "djwqj238ewoc1234jlui1234yuit1256"
    let key = new Uint8Array(key1.length)
    for (let i = 0; i < key1.length; i++) {
      key[i] = key1.charCodeAt(i)
    }
    let iv1 = "adid3456yioe9861"
    let iv = new Uint8Array(iv1.length)
    for (let i = 0; i < key1.length; i++) {
      iv[i] = iv1.charCodeAt(i)
    }
    let awaitEncryptStr = await AES.encrypt256(message, key, iv)
    console.log("256 awaitEncryptStr: " + awaitEncryptStr.data.toString())
    let awaitDecryptStr = await AES.decrypt256(awaitEncryptStr, key, iv)
    console.log("256 awaitDecryptStr: " + awaitDecryptStr)
    return awaitEncryptStr.data.toString()
  }

  async aes128Func(message: string): Promise<string> {
    let key = AES.createAES128Key()
    let iv = AES.creatAESIv()
    let awaitEncryptStr = await AES.encrypt128(message, key, iv)
    console.log("awaitEncryptStr: " + awaitEncryptStr.data.toString())
    let awaitDecryptStr = await AES.decrypt128(awaitEncryptStr, key, iv)
    console.log("awaitDecryptStr: " + awaitDecryptStr)
    return awaitEncryptStr.data.toString()
  }

  async rsaFunc(message: string): Promise<string> {
    let privateKey = "MIICWgIBAAKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQABAn8GNTdnSDdWzitNVTRsxduVPpciQbzKETSgMfRZ8P25KEG2Jug8XIJxw2sfyitncvjjFOLK2CoHtrF1Xtt1CAUV3j3OMcNnbAUgMuhNHpnSDCLKMN5f/DcfgxqMlPDJRzFutX6dWlxFbCZor6fxZ0yJZJvEqo3DF3PNmY9csw0RAkEAoS/tCk77BjdOlLo8I69z/C6ry3jGesxsS7BUaPumCArLrcWMDnCtwCt9QBWzIvy5zxxYmU4obBWrNGhjbIthMwJBAOd2tDv5JGNnwj9pFIK4G7UgikGte5qm8Voqbft8i5puexNwcbYYAriBzWDMOVHf891KWAcqV0w6PP5aUoq4h0kCQD2cLgSUr8pudXDPxpD1TWYFCNFbNrJVVMeRfJIsLghA6B1htukGFMOxW8yU/sXOx87sTMk8YKL/nVMI24fvtpUCQQDLnnRdkgX94MhUKied+0J8q5yUvH3RBe2qSUspgl35RBnHdxLBgwvZrm6zKdV+/km0sXMREqFrcIw5odGdMUnpAkA65O6hyyZ4aH50kS3x7cfbRKPFRjGl6ugA6mtoubhnWrV+Z0lyBXLdnd+hhd2PacpdyK7IZbymsuBge6rEHae7"
    let publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQAB"

    let awaitEncryptStr = await RSA.encryptByPub(message, publicKey)
    console.log("rsa awaitEncryptStr: " + awaitEncryptStr.data.toString())
    let awaitDecryptStr = await RSA.decryptByPri(awaitEncryptStr, privateKey)
    console.log("rsa awaitDecryptStr: " + awaitDecryptStr)
    return awaitEncryptStr.data.toString()
  }

  async rsaFunc1(message: string): Promise<string> {
    let privateKey = "MIICWgIBAAKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQABAn8GNTdnSDdWzitNVTRsxduVPpciQbzKETSgMfRZ8P25KEG2Jug8XIJxw2sfyitncvjjFOLK2CoHtrF1Xtt1CAUV3j3OMcNnbAUgMuhNHpnSDCLKMN5f/DcfgxqMlPDJRzFutX6dWlxFbCZor6fxZ0yJZJvEqo3DF3PNmY9csw0RAkEAoS/tCk77BjdOlLo8I69z/C6ry3jGesxsS7BUaPumCArLrcWMDnCtwCt9QBWzIvy5zxxYmU4obBWrNGhjbIthMwJBAOd2tDv5JGNnwj9pFIK4G7UgikGte5qm8Voqbft8i5puexNwcbYYAriBzWDMOVHf891KWAcqV0w6PP5aUoq4h0kCQD2cLgSUr8pudXDPxpD1TWYFCNFbNrJVVMeRfJIsLghA6B1htukGFMOxW8yU/sXOx87sTMk8YKL/nVMI24fvtpUCQQDLnnRdkgX94MhUKied+0J8q5yUvH3RBe2qSUspgl35RBnHdxLBgwvZrm6zKdV+/km0sXMREqFrcIw5odGdMUnpAkA65O6hyyZ4aH50kS3x7cfbRKPFRjGl6ugA6mtoubhnWrV+Z0lyBXLdnd+hhd2PacpdyK7IZbymsuBge6rEHae7"
    let publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQAB"

    let awaitEncryptStr = await RSA.encryptByPri(message, privateKey)
    console.log("rsa awaitEncryptStr1: " + awaitEncryptStr.data.toString())
    let awaitDecryptStr = await RSA.decryptByPub(awaitEncryptStr, publicKey)
    console.log("rsa awaitDecryptStr1: " + awaitDecryptStr)
    return awaitEncryptStr.data.toString()
  }

  async sm2Func1(message: string): Promise<string> {
    let sm2PrivateKeyStr = "16A815B5558C1E816A70340D8CF56D92319D38393A7EE30EA188D8CC5F16CFB1"
    let sm2PublicKeyStr = "ED6EC968296E41AA61FBFD2ADAE6F0B3DDC21FF3F10DC0F206781B58334870B07121F08027B6D21350104EEFA677DCE58FB0BC5F063037A86D8380DFB66DAD46"
    let awaitEncryptStr = await SM2.encryptByPub(message, sm2PublicKeyStr)
    console.log("sm2 awaitEncryptStr: " + awaitEncryptStr.data.toString())
    let dataToHex = SM2.byteArrayToHex(awaitEncryptStr.data)
    console.log("sm2 hexString: " + dataToHex)
    let hexToData = SM2.hexToByteArray(dataToHex)
    let hexToDataBlob: cryptoFramework.DataBlob = {data: hexToData}
    let awaitDecryptStr = await SM2.decryptByPri(hexToDataBlob, sm2PrivateKeyStr)
    console.log("sm2 awaitDecryptStr1: " + awaitDecryptStr)
    return awaitEncryptStr.data.toString()
  }

  async sm2Func2() {
    let puk: Uint8Array | null = await this.sm2Model.initImportPuk()
    await this.sm2Model.convertKeyImportPuk(puk)
    let data: string = await this.sm2Model.convertKeyImportPuk1(puk)
    console.log("sm2Func2:" + data)
  }

  async rsaSignFunc(message: string): Promise<string> {
    let privateKey = "MIICWgIBAAKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQABAn8GNTdnSDdWzitNVTRsxduVPpciQbzKETSgMfRZ8P25KEG2Jug8XIJxw2sfyitncvjjFOLK2CoHtrF1Xtt1CAUV3j3OMcNnbAUgMuhNHpnSDCLKMN5f/DcfgxqMlPDJRzFutX6dWlxFbCZor6fxZ0yJZJvEqo3DF3PNmY9csw0RAkEAoS/tCk77BjdOlLo8I69z/C6ry3jGesxsS7BUaPumCArLrcWMDnCtwCt9QBWzIvy5zxxYmU4obBWrNGhjbIthMwJBAOd2tDv5JGNnwj9pFIK4G7UgikGte5qm8Voqbft8i5puexNwcbYYAriBzWDMOVHf891KWAcqV0w6PP5aUoq4h0kCQD2cLgSUr8pudXDPxpD1TWYFCNFbNrJVVMeRfJIsLghA6B1htukGFMOxW8yU/sXOx87sTMk8YKL/nVMI24fvtpUCQQDLnnRdkgX94MhUKied+0J8q5yUvH3RBe2qSUspgl35RBnHdxLBgwvZrm6zKdV+/km0sXMREqFrcIw5odGdMUnpAkA65O6hyyZ4aH50kS3x7cfbRKPFRjGl6ugA6mtoubhnWrV+Z0lyBXLdnd+hhd2PacpdyK7IZbymsuBge6rEHae7"
    let publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCRvPx3BZpSHLMmnToIaz8hs5SeggIzT0BWitPQ1tnxmK6qkm/zTL8StB3HZwkFlJKC8JvIexEtM6LIe6yVa1aW8Ha466shhpRywMuP4rWGUUOQcq+hB1wyW87IbJzIGHyK4ic7BwYDsGZCT668qpysCB+TTXq6eAk+YmmAzqiciwIDAQAB"
    let awaitSignStr = await RSASign.sign(message, privateKey)
    console.log("rsaSign awaitSignStr: " + awaitSignStr.data.toString())
    let success = await RSASign.verify(message, awaitSignStr, publicKey)
    console.log("sign awaitSignResult: " + success)
    return awaitSignStr.data.toString()
  }

  async sm4Func(message: string): Promise<string> {
    let key = "5BE4C0E990F04A33"
    let awaitEncryptStr = await SM4.encrypt(message, key)
    console.log("sm4 awaitEncryptStr: " + awaitEncryptStr.data.toString())
    let awaitDecryptStr = await SM4.decrypt(awaitEncryptStr, key)
    console.log("sm4 awaitDecryptStr: " + awaitDecryptStr)
    return awaitEncryptStr.data.toString()
  }

  aboutToAppear(): void {

    // myAsyncFunction().then() {
    //   console.log("then")
    // }
    myAsyncFunction()
    console.log("Hello, world!2")

    endFunc()

    // aes
    // let arr = [1, 2];
    // let arr1 = new Uint8Array(arr);
    // arr = [3, 4];
    // let arr2 = new Uint8Array(arr);
    // let arr3 = this.aesModel.concatUint8Array(arr1, arr2);
    // console.log(`arr3 = ${arr3.toString()}`);

    // this.aesModel.aesEncrypt("在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。")
    // this.aesModel.aesEncrypt("message");

    // aes 导入外部密钥
    let key1: Array<number> = [52,100,101,99,86,108,66,90,101,66,98,55,108,85,103,85,49,84,53,65,48,101,51,74,68,100,87,107,51,112,50,110]
    let key = new Uint8Array(key1.length)
    for (let i = 0; i < key1.length; i++) {
      key[i] = key1[i]
    }
    let hbmessage = "7332914851BCEBA237CFEEF52826053C423CFE4928DACD728FAB12084909C5201EA196B85349A2896CB3C5B3E2F10246FCE9B15DCD5548B259B16CF3C71CE0B91E50364D1C784A928CEA665DB0F43F2EE8E2A1905BB38721F923D3550B2AFD98E4D3DBD164785A944E42E121C43661CDEE1FFF9B2368AEA433F4C6A4282B611F793CB8344380ED6180B9D7C03E9F0BC9D8FE4A9C12316822716063CFA7BAA1BEA0C792D268CAFA047576E88FB3468600DA4C060C77C5095F4BD49AAA15E7BED733A542B8DB1AF09004EFCC3C078F70076B05BC2FCCE8CA000EF1F89D1986136849D42760EBE37333B1B8C65B0BBF8102037F2A989C13AE4459296060D34DB7FF8ACBF845049E5BA93B7628D4FF62B1D88F850120A9250D483D4C260C40AAB19D42235755E4653652FEA6033866256EB881F43E23F78BA9C40C981F46E93255007FBAE7D7762F491B508001D4B81B1141401A0EAF1F39F69C4A4972B872A4CC76A45D4CA0904818812D846292E0E74212B62B2CEF697383A2C23FF6DF305F0DAA051696905C41F67706B84D223412DE1B01273FAAE9E5E048DC4C5A3144A164238BF9FC768C5C08AF2F4DAC4BDE3C6BE7313116006A806B9F9EC6B0BAB4C6678C7F57DB2C3BF0322CAC4D3565C2F1F76508C5676E26BDEDCC3F371FBCDC2142F7F94FAB90759133746219C873F4C0A19EE1103D4547392AE85912EFAE72D0507A38547FFDE8C799A5468056B50C383136AAAB0E3B0C80B32F2E247D2BA72E91FC00E8D246DCBC8C2C2AA49595A725F805522C294B88823095B0FCF25F60F2BE2C16EF4214563685F3CA25FAE24E5F081C57DD631BA59D59A4DA1F5FCC6D84BB582157C4AB003AED71DE9D31FD431A996F49C215D538B9E45EFD61AD0EC73B73640B559842D5B9E7B881DA6679FC2552A47727F11704669E5DB43AFC0D3EC2B181EADC41D71809225772961F3D779C5C9F3DF87368AFA07561A2CEF0CFA9BCFE218DE62596942CDB054CB6F6AE3F4698163AB7F35F613797E9AD4B2081BFCB42615EBB4F99831A187E66341C7C186468E94F212EB78E5AF335200AD343B9071ADA02622E7B8CB929C072A3C6B0E1BCA6EE3094897BCFB2AA90646C650ECEF524AAC1E1C2DBFEACE60580048E06E88A06C564693107DFF9336651199D082257DE35A5A77E3CC7B2FA0C417CB4C643852DC13A57D4202EB111CA2A8E4452C60671E67A894ACCCD90C3A272F7553690037B1F3FC001B4080D4255ACA93097C09B386CAA532D640E284070E0ADEBE4E0EFC505E30382E1418136A674A4CF2C389840996B4D5E3DE5AB812724674981F99A672B906E34B4889416341026E114EA436D7B761A4AD9363C821E58E3755B7CAF0DCC72F718C51893635B493E3AEE9B7A2A73E189B4C60CDFADDB0AB5CE0CF68DC31EDC1EB29254DC3BAD16B6887B4A1A6240"
    this.aesModel.aesEncryptA(hbmessage, key)
    this.aesModel.aesDecryptB(hbmessage)
    // this.aesModel.aesEncryptA("aes256 message3", key)

    // this.aesModel.aesEncrypt("aes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes message")
    // this.aesModel.aesEncrypt("加密内容")
    // this.aesModel.aesEncrypt("对称加解密中调用doFinal标志着一次加解密流程已经完成即Cipher实例的状态被清除因此当后续开启新一轮加解密流程时需要重新调用init()并传入完整的参数列表进行初始化")
    // this.aesModel.aesEncrypt("对称加解密中，调用doFinal标志着一次加解密流程已经完成，即Cipher实例的状态被清除，因此当后续开启新一轮加解密流程时，需要重新调用init()并传入完整的参数列表进行初始化（比如即使是对同一个Cipher实例，采用同样的对称密钥，进行加密然后解密，则解密中调用init的时候仍需填写params参数，而不能直接省略为null）。如果遇到解密失败，需检查加解密数据和init时的参数是否匹配，包括GCM模式下加密得到的authTag是否填入解密时的GcmParamsSpec等。doFinal的结果可能为null，因此使用.data字段访问doFinal结果的具体数据前，请记得先判断结果是否为null，避免产生异常。RSA、SM2非对称加解密时多次doFinal操作的示例代码详见开发指导“使用加解密操作”。")

    // let arr: Uint8Array = this.aesModel.stringToUint8Array("加密内容")
    // console.log(`arr: ${arr.toString()}`)
    // let str = this.aesModel.uint8ArrayToString(arr);
    // console.log(`uint8ArrayToString:${str}`);
    // let str1 = "加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes"
    // let bytes = this.aesModel.stringToBytes(str1)
    // console.log(`bytes: ${bytes.toString()}`)
    // let byteStr = this.aesModel.byteToString(bytes)
    // console.log(`byteStr: ${byteStr}`)


    // this.aesModel.stringToUint8ArrayByUTF8("")
    // let aesKey = this.aesModel.createAESKey()
    // console.log(`aesKey: ${aesKey.toString()}`)

    // this.aesModel.aesEncryptA("aes encrypt message", this.aesModel.createAESKey())
    // let awaitStr = this.aesModel.encrypt("aes encrypt message", this.aesModel.createAESKey())
    // console.log("awaitStr: " + awaitStr)
    // let aesFuncStr = this.aesFunc("aes encrypt message")
    this.aes128Func("aes128 encrypt message，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes")
    // console.log("aesFuncStr:" + aesFuncStr)
    // console.log("aesFuncStr1:" + aesFuncStr1)
    // this.aes256Func("aes256 encrypt message，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes")
    // this.aes256Func("aes256 encrypt message，加密内容aes，加密内容aes加密内容aes array")
    // this.aes256Func(hbmessage)
    // this.aes256DecryptFunc(hbmessage)

    // rsa
    // this.rsaModel.encryptMessagePromise("rsa message1")
    // this.rsaModel.decryptMessagePromise()
    // this.rsaModel.decryptMessagePromise3("rsa message 64")
    // this.rsaModel.decryptMessagePromise3("rsa message 64 reverse")

    // this.rsaModel.decryptMessagePromise2("rsa message 64 reverse")

    // let rsaFuncStr1 = this.rsaFunc("rsa message await")
    // console.log("rsaFuncStr1:" + rsaFuncStr1)
    // let rsaFuncStr2 = this.rsaFunc("rsa message await, 加密内容rsa，加密内容aes加密内容rsa，加密内容aes加密内容rsa")
    // console.log("rsaFuncStr2:" + rsaFuncStr2)
    //
    // let rsaFuncStr3 = this.rsaFunc1("rsa message await1")
    // console.log("rsaFuncStr3:" + rsaFuncStr3)
    // let rsaFuncStr4 = this.rsaFunc1("rsa message await1, 加密内容rsa，加密内容aes加密内容rsa，加密内容aes加密内容rsa")
    // console.log("rsaFuncStr4:" + rsaFuncStr4)

    // sm2
    // sm2Model.encryptMessagePromise()
    // this.sm2Model.decryptMessagePromise("sm2 message")
    // this.sm2Model.encryptMessagePromiseA("sm2 message convert")
    // this.sm2Model.encryptMessagePromiseB("sm2 message convert")
    // this.sm2Func1("sm2 message convert pub await 12,加密内容aes加密内容sm2")
    // this.sm2Func1("297970")
    this.sm2Func2()

    // ECC
    // this.eccModel.convertKeyFunc()

    // SM4
    // this.sm4Model.testSM4Ecb()
    // this.sm4Func("sm4SignFunc")

    // MyUtils
    let str1 = "加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes加密内容aes，加密内容aes"
    let bytes = MyUtils.stringToBytes(str1)
    console.log(`bytes: ${bytes.toString()}`)
    let byteStr = MyUtils.byteToString(bytes)
    console.log(`byteStr: ${byteStr}`)

    let result = new Uint8Array(6);
    result[0] = 0xEF;
    result[1] = 0xBB;
    result[2] = 0xBF;
    result[3] = 0x61;
    result[4] = 0x62;
    result[5] = 0x63;
    let decodeStr = MyUtils.textDecodeByUtf8(result)
    console.log("decodeStr = " + decodeStr)
    let encodeArr = MyUtils.textEncodeByUtf8("abc")
    console.log("encodeArr = " + encodeArr.toString())

    let buf1 = buffer.from("1234")
    let buf2 = buffer.from("abcd")
    let buf = buffer.concat([buf1, buf2])
    console.log("hex:" + buf.toString('hex')) // 3132333461626364

    // RSA sign
    // this.rsaSignModel.signMessagePromise("rsa sign")
    // this.rsaSignModel.signMessagePromise1("rsa sign1")
    // this.rsaSignModel.verifyMessagePromise()
    // this.rsaSignFunc("rsa sign2")

  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}

function verifyMessagePromise() {
  throw new Error('Function not implemented.')
}
