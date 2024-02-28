import cryptoFramework from '@ohos.security.cryptoFramework';
import { BusinessError } from '@ohos.base';
import util from '@ohos.util';
import {SM2_Ciphertext} from './SM2Text'
// import { SM2_SEQUENCE } from './sm2Sequence';
import {MyUtils} from '../utilities/MyUtils'

let plan = "This is cipher test.";
let cipherDataBlob: cryptoFramework.DataBlob;

export class SM2 {
  // Convert strings in plaintext into byte streams.
  stringToUint8Array(str: string) {
    let arr = new Uint8Array(str.length);
    for (let i = 0, j = str.length; i < j; ++i) {
      arr[i] = str.charCodeAt(i);
    }
    return arr;
  }

  Uint8ArrayToString(arr: Uint8Array) {
    let str = ""
    for (let i = 0; i < arr.length; i++) {
      str += String.fromCharCode(arr[i])
    }
    return str
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

  static byteArrayToHex(bytes: Uint8Array): string {
    let retorno = "";
    if (bytes !== null && bytes.length !== 0) {
      for (let i = 0; i < bytes.length; ++i) {
        let valor = bytes[i];
        let d1 = valor & 0xf;
        d1 += d1 < 10 ? 48 : 55;
        let d2 = (valor & 0xf0) >> 4;
        d2 += d2 < 10 ? 48 : 55;
        retorno = retorno + String.fromCharCode(d2) + String.fromCharCode(d1);
      }
      return retorno;
    } else {
      return retorno;
    }
  }

  static hexToByteArray(hexa: string): Uint8Array {
    if (hexa == null) {
      throw new Error();
    }
    if ((hexa.length % 2) != 0) {
      throw new Error();
    }
    let tamArray = hexa.length / 2;
    let retorno = new Uint8Array(tamArray);
    for (let i = 0; i < tamArray; i++) {
      retorno[i] = SM2.hexToByte(hexa.substring(i * 2, i * 2 + 2));
    }
    return retorno;
  }

  static hexToByte(hexa: string): number {
    if (hexa === null) {
      throw new Error();
    } else if (hexa.length !== 2) {
      throw new Error();
    } else {
      const valor = (SM2.hexDigitValue(hexa.charAt(0)) * 16 + SM2.hexDigitValue(hexa.charAt(1)));
      return valor;
    }
  }

  static hexDigitValue(c: string): number {
    let retorno = 0;
    if (c >= '0' && c <= '9') {
      retorno = c.charCodeAt(0) - 48;
    } else if (c >= 'A' && c <= 'F') {
      retorno = c.charCodeAt(0) - 55;
    } else {
      if (c < 'a' || c > 'f') {
        throw new Error();
      }

      retorno = c.charCodeAt(0) - 87;
    }

    return retorno;
  }

  static genSM2CommonSpec(): cryptoFramework.ECCCommonParamsSpec {
    let fieldFp: cryptoFramework.ECFieldFp = {
      fieldType: "Fp",
      p: BigInt("0xFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFF")
    }
    let G: cryptoFramework.Point = {
      x: BigInt("0x32C4AE2C1F1981195F9904466A39C9948FE30BBFF2660BE1715A4589334C74C7"),
      y: BigInt("0xBC3736A2F4F6779C59BDCEE36B692153D0A9877CC62A474002DF32E52139F0A0")
    }
    let SM2CommonSpec: cryptoFramework.ECCCommonParamsSpec = {
      algName: "ECC",
      specType: cryptoFramework.AsyKeySpecType.COMMON_PARAMS_SPEC,
      field: fieldFp,
      a: BigInt("0xFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFC"),
      b: BigInt("0x28E9FA9E9D9F5E344D5A9E4BCF6509A7F39789F515AB8F92DDBCBD414D940E93"),
      g: G,
      n: BigInt("0xFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFF7203DF6B21C6052B53BBF40939D54123"),
      h: 1
    }
    return SM2CommonSpec;
  }

  // 公钥加密
  static async encryptByPub(message: string, pubkey: string): Promise<cryptoFramework.DataBlob> {
    let length = pubkey.length
    let tmpStr1 = pubkey.substring(0, length / 2)
    let tmpStr2 = pubkey.substring(length / 2, length)
    let pubkeyPart1 = "0x" + tmpStr1
    let pubkeyPart2 = "0x" + tmpStr2
    // 64字节公钥数据
    let pk: cryptoFramework.Point = {
      x: BigInt(pubkeyPart1),
      y: BigInt(pubkeyPart2)
    }
    // 公钥对象参数
    let pubKeySpec: cryptoFramework.ECCPubKeySpec = {
      params: SM2.genSM2CommonSpec(),
      pk: pk,
      algName: "ECC",
      specType: cryptoFramework.AsyKeySpecType.PUBLIC_KEY_SPEC // 指定公钥类型
    }
    // Create a Cipher instance for encryption.
    let cipher = cryptoFramework.createCipher("SM2_256|SM3")

    // let globalPubkey: cryptoFramework.PubKey
    // let cipherDataBlob: cryptoFramework.DataBlob
    let input: cryptoFramework.DataBlob = {data: SM2.textEncodeByUtf8(message)}

    let pubkeyGenerator = cryptoFramework.createAsyKeyGeneratorBySpec(pubKeySpec)
    let sm2PubKey = await pubkeyGenerator.generatePubKey()
    let pubKeyArr: Uint8Array = sm2PubKey.getEncoded().data
    let pubKeyBlob: cryptoFramework.DataBlob = { data: pubKeyArr }
    // 传入公钥数据生成密钥对象
    let generator = cryptoFramework.createAsyKeyGenerator("SM2_256")
    let sm2KeyPair = await generator.convertKey(pubKeyBlob, null)
    console.log("sm2 convert SM2 keyPair success")
    await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, sm2KeyPair.pubKey, null)
    let input1: cryptoFramework.DataBlob = {data: input.data}
    let globalCipherData = await cipher.doFinal(input1)
    console.info(`doFinal cipher success.`);
    console.log("rsa encrypt globalCipherData:" + globalCipherData.data.toString())
    return globalCipherData
  }

  // 私钥解密
  static async decryptByPri(message: cryptoFramework.DataBlob, prikey: string): Promise<string> {
    // 32字节私钥数据
    let prikey1 = "0x" + prikey
    let sk: bigint = BigInt(prikey1)
    // 私钥对象参数
    let priKeySpec: cryptoFramework.ECCPriKeySpec = {
      params: SM2.genSM2CommonSpec(),
      sk: sk,
      algName: "ECC",
      specType: cryptoFramework.AsyKeySpecType.PRIVATE_KEY_SPEC // 指定私钥类型
    }
    // Create a Cipher instance for decryption.
    let decoder = cryptoFramework.createCipher("SM2_256|SM3")

    let prikeyGenerator = cryptoFramework.createAsyKeyGeneratorBySpec(priKeySpec)
    let sm2PriKey = await prikeyGenerator.generatePriKey()
    let priKeyArr: Uint8Array = sm2PriKey.getEncoded().data
    let priKeyBlob: cryptoFramework.DataBlob = { data: priKeyArr }

    // 传入私钥数据生成密钥对象
    let generator = cryptoFramework.createAsyKeyGenerator("SM2_256")
    let sm2KeyPair = await generator.convertKey(null, priKeyBlob)
    console.log("sm2 convert SM2 keyPair success")
    await decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, sm2KeyPair.priKey, null)
    let plainText: cryptoFramework.DataBlob = message
    console.log(`plainText:${plainText.data.toString()}`)
    let globalCipherData = await decoder.doFinal(plainText)
    console.info(`doFinal cipher success.`);
    console.log("rsa decrypt globalCipherData:" + globalCipherData.data.toString())
    let decryptStr = SM2.textDecodeByUtf8(globalCipherData.data)
    console.log("rsa decryptStr:" + decryptStr)
    return decryptStr
  }

  async initImportPuk(): Promise<Uint8Array> {

    let pk: cryptoFramework.Point = {
      x: BigInt("0x5A033A9DBEF84C0784C897D070E6608C5AEED39B806DF82853D64E2A686A3794"),
      y: BigInt("0xF9233D20DD878F642D61C2B0344988AE284646226767A1631BBB0DBB6DF40D07")
    }

    let sk: bigint = BigInt("0x6d562d653d74f41bff9c3f2359e5add416a931c44783b9afdf5c3327121c2266");
    // 公钥对象参数
    let pubKey: cryptoFramework.ECCPubKeySpec = {
      params: SM2.genSM2CommonSpec(),
      pk: pk,
      algName: "ECC",
      specType: cryptoFramework.AsyKeySpecType.PUBLIC_KEY_SPEC
    }
    // 私钥对象数据
    let priKey: cryptoFramework.ECCPriKeySpec = {
      params: SM2.genSM2CommonSpec(),
      sk: sk,
      algName: "ECC",
      specType: cryptoFramework.AsyKeySpecType.PRIVATE_KEY_SPEC
    }
    // 密钥对对象数据
    let keyPair: cryptoFramework.ECCKeyPairSpec = {
      params: SM2.genSM2CommonSpec(),
      sk: sk,
      pk: pk,
      algName: 'ECC',
      specType: cryptoFramework.AsyKeySpecType.KEY_PAIR_SPEC
    }

    let puk: Uint8Array = new Uint8Array()
    try {
      let KeyPairGenerator: cryptoFramework.AsyKeyGeneratorBySpec;
      KeyPairGenerator = cryptoFramework.createAsyKeyGeneratorBySpec(pubKey);
      let KeyPair = await KeyPairGenerator.generatePubKey()
      puk = KeyPair.getEncoded().data
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error(`sync error, ${e.code}, ${e.message}`);
    }
    return puk;
  }

  async convertKeyImportPuk1(pubKey: Uint8Array): Promise<string> {
    console.log("PubKey code : " + MyUtils.uint8ArrayToHexStr(pubKey));
    console.log("PubKey data : " + MyUtils.base64Encode(pubKey));
    console.log("================================================================");
    let pubKeyBlob: cryptoFramework.DataBlob = { data: pubKey };

    console.log("================================================================");

    let cipher = cryptoFramework.createCipher("SM2_256|SM3");
    let decoder = cryptoFramework.createCipher("SM2_256|SM3");
    let generator = cryptoFramework.createAsyKeyGenerator("SM2_256");


    let keypair: cryptoFramework.KeyPair = await generator.convertKey(pubKeyBlob, null)
    console.log("sm2 PubKey base64 : " + MyUtils.base64Encode(keypair.pubKey.getEncoded().data));
    console.log("sm2 PubKey data : " + MyUtils.uint8ArrayToHexStr(keypair.pubKey.getEncoded().data));
    console.log("================================================================");
    await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, keypair.pubKey, null)
    let input: cryptoFramework.DataBlob = { data: MyUtils.stringToUint8Array("123456") }
    let cipherDataBlob: cryptoFramework.DataBlob = await cipher.doFinal(input)

    console.info("SM2 EncryptOutPut base64 is " + MyUtils.base64Encode(cipherDataBlob.data));
    console.info("SM2 EncryptOutPut hexStr is " + MyUtils.uint8ArrayToHexStr(cipherDataBlob.data));
    console.info("SM2 EncryptOutPut primal is " + new SM2_Ciphertext().d2i_SM2_Ciphertext(MyUtils.uint8ArrayToHexStr(cipherDataBlob.data)));
    console.log("================================================================");

    let encryStr = new SM2_Ciphertext().d2i_SM2_Ciphertext(MyUtils.uint8ArrayToHexStr(cipherDataBlob.data))

    return encryStr
  }

  async convertKeyImportPuk(pubKey: Uint8Array) {

    console.log("PubKey code : " + MyUtils.uint8ArrayToHexStr(pubKey));
    console.log("PubKey data : " + MyUtils.base64Encode(pubKey));
    console.log("================================================================");
    let pubKeyBlob: cryptoFramework.DataBlob = { data: pubKey };

    console.log("================================================================");

    let cipher = cryptoFramework.createCipher("SM2_256|SM3");
    let decoder = cryptoFramework.createCipher("SM2_256|SM3");
    let generator = cryptoFramework.createAsyKeyGenerator("SM2_256");

    let input: cryptoFramework.DataBlob

    let keypair: cryptoFramework.KeyPair;

    try {
      generator.convertKey(pubKeyBlob, null)
        .then((keyPair) => {
          keypair = keyPair;
          console.log("sm2 PubKey base64 : " + MyUtils.base64Encode(keypair.pubKey.getEncoded().data));
          console.log("sm2 PubKey data : " + MyUtils.uint8ArrayToHexStr(keypair.pubKey.getEncoded().data));
          // console.log("sm2 PriKey base64 : " + baseUtil.base64Encode(keypair.priKey.getEncoded().data));
          // console.log("sm2 PriKey data : " + baseUtil.uint8ArrayToHexStr(keypair.priKey.getEncoded().data));
          console.log("================================================================");
          return cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, keypair.pubKey, null);
        })
        .then(() => {
          // doFinal
          input = { data: MyUtils.stringToUint8Array("123456") };
          return cipher.doFinal(input);
        })
        .then(async dataBlob => {
          // 获取加密数据。
          console.info("SM2 EncryptOutPut base64 is " + MyUtils.base64Encode(dataBlob.data));
          console.info("SM2 EncryptOutPut hexStr is " + MyUtils.uint8ArrayToHexStr(dataBlob.data));
          console.info("SM2 EncryptOutPut primal is " + new SM2_Ciphertext().d2i_SM2_Ciphertext(MyUtils.uint8ArrayToHexStr(dataBlob.data)));
          console.log("================================================================");
          cipherDataBlob = dataBlob
          return dataBlob
          // return decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, keypair.priKey, null)
        })
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error(`sync error, ${e.code}, ${e.message}`);
      AlertDialog.show({ message: "Convert keypair fail" });
    }
  }

  async convertKeyImportPri(priKey: Uint8Array) {
    console.log("PubKey code : " + MyUtils.uint8ArrayToHexStr(priKey));
    console.log("PubKey data : " + MyUtils.base64Encode(priKey));
    console.log("================================================================");
    let priKeyBlob: cryptoFramework.DataBlob = { data: priKey };

    console.log("================================================================");

    let cipher = cryptoFramework.createCipher("SM2_256|SM3");
    let decoder = cryptoFramework.createCipher("SM2_256|SM3");
    let generator = cryptoFramework.createAsyKeyGenerator("SM2_256");

    let input: cryptoFramework.DataBlob

    let keypair: cryptoFramework.KeyPair;

    try {
      generator.convertKey(priKeyBlob, null)
        .then((keyPair) => {
          keypair = keyPair;
          console.log("sm2 priKey base64 : " + MyUtils.base64Encode(keypair.priKey.getEncoded().data));
          console.log("sm2 priKey data : " + MyUtils.uint8ArrayToHexStr(keypair.priKey.getEncoded().data));
          // console.log("sm2 PriKey base64 : " + baseUtil.base64Encode(keypair.priKey.getEncoded().data));
          // console.log("sm2 PriKey data : " + baseUtil.uint8ArrayToHexStr(keypair.priKey.getEncoded().data));
          console.log("================================================================");
          return decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, keypair.priKey, null);
        })
        .then(() => {
          // doFinal
          // input = { data: MyUtils.stringToUint8Array("123456") };
          return cipher.doFinal(cipherDataBlob);
        })
        .then(async dataBlob => {
          // 获取解密数据。
          // console.info("SM2 DecryptOutPut is" + MyUtils.)
          // console.info("SM2 DecryptOutPut base64 is " + MyUtils.base64Encode(dataBlob.data));
          // console.info("SM2 DecryptOutPut hexStr is " + MyUtils.uint8ArrayToHexStr(dataBlob.data));
          // console.info("SM2 DecryptOutPut primal is " + new SM2_Ciphertext().d2i_SM2_Ciphertext(MyUtils.uint8ArrayToHexStr(dataBlob.data)));
          console.log("================================================================");
          cipherDataBlob = dataBlob
          return dataBlob
          // return decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, keypair.priKey, null)
        })
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error(`sync error, ${e.code}, ${e.message}`);
      AlertDialog.show({ message: "Convert keypair fail" });
    }

  }

  encryptMessagePromiseB(message: string) {
    // let privateKeyStr = "16A815B5558C1E816A70340D8CF56D92319D38393A7EE30EA188D8CC5F16CFB1"
    // let publicKeyStr  = "ED6EC968296E41AA61FBFD2ADAE6F0B3DDC21FF3F10DC0F206781B58334870B07121F08027B6D21350104EEFA677DCE58FB0BC5F063037A86D8380DFB66DAD46"
    // 64字节公钥数据
    let pk: cryptoFramework.Point = {
      x: BigInt("0xED6EC968296E41AA61FBFD2ADAE6F0B3DDC21FF3F10DC0F206781B58334870B0"),
      y: BigInt("0x7121F08027B6D21350104EEFA677DCE58FB0BC5F063037A86D8380DFB66DAD46")
    }
    // 32字节私钥数据
    let sk: bigint = BigInt("0x16A815B5558C1E816A70340D8CF56D92319D38393A7EE30EA188D8CC5F16CFB1")

    // // 64字节公钥数据
    // let pk: cryptoFramework.Point = {
    //   x: BigInt("0x5A033A9DBEF84C0784C897D070E6608C5AEED39B806DF82853D64E2A686A3794"),
    //   y: BigInt("0xF9233D20DD878F642D61C2B0344988AE284646226767A1631BBB0DBB6DF40D07")
    // }
    // // 32字节私钥数据
    // let sk: bigint = BigInt("0x3629EFF03FBC86711F6695CBF5590F0F2FCAAA3C269A1CA9BD64FB4C70DF9C9F")
    // 下面列出公钥、私钥和密钥对的参数模板，根据实际场景三选一
    // 公钥对象参数
    let pubKey: cryptoFramework.ECCPubKeySpec = {
      params: SM2.genSM2CommonSpec(),
      pk: pk,
      algName: "ECC",
      specType: cryptoFramework.AsyKeySpecType.PUBLIC_KEY_SPEC // 指定公钥类型
    }
    // 私钥对象参数
    let priKey: cryptoFramework.ECCPriKeySpec = {
      params: SM2.genSM2CommonSpec(),
      sk: sk,
      algName: "ECC",
      specType: cryptoFramework.AsyKeySpecType.PRIVATE_KEY_SPEC // 指定私钥类型
    }
    // 密钥对对象参数
    let keyPair: cryptoFramework.ECCKeyPairSpec = {
      params: SM2.genSM2CommonSpec(),
      sk: sk,
      pk: pk,
      algName: 'ECC',
      specType: cryptoFramework.AsyKeySpecType.KEY_PAIR_SPEC // 指定密钥对类型
    }

    // Create a Cipher instance for encryption.
    let cipher = cryptoFramework.createCipher("SM2_256|SM3")
    // Create a Cipher instance for decryption.
    let decoder = cryptoFramework.createCipher("SM2_256|SM3")

    let sm2KeyPair: cryptoFramework.KeyPair
    let cipherDataBlob: cryptoFramework.DataBlob
    let input: cryptoFramework.DataBlob = {data: SM2.textEncodeByUtf8(message)}

    let KeyPairGenerator: cryptoFramework.AsyKeyGeneratorBySpec
    KeyPairGenerator = cryptoFramework.createAsyKeyGeneratorBySpec(keyPair)
    let sm2Generator: cryptoFramework.AsyKeyGenerator
    let pubKeyBlob: cryptoFramework.DataBlob
    let priKeyBlob: cryptoFramework.DataBlob

    KeyPairGenerator.generateKeyPair()
      .then((keyPair) => {
        // 获取公钥数据
        let pubKey = keyPair.pubKey
        let pubKeyArr: Uint8Array = pubKey.getEncoded().data
        pubKeyBlob = { data: pubKeyArr }
        // 获取私钥数据
        let priKey = keyPair.priKey
        let priKeyArr: Uint8Array = priKey.getEncoded().data
        priKeyBlob = { data: priKeyArr }
        // 传入公私钥数据生成密钥对象
        sm2Generator = cryptoFramework.createAsyKeyGenerator("SM2_256")
        sm2Generator.convertKey(pubKeyBlob, priKeyBlob)
          .then((keyPair1) => {
            sm2KeyPair = keyPair1
            console.log("convert SM2 keyPair success")
            return cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, sm2KeyPair.pubKey, null)
          })
          .catch((err: BusinessError) => {
            console.log(JSON.stringify(err))
          })
          .then(() => {
            // doFinal
            let input1: cryptoFramework.DataBlob = {data: input.data}
            return cipher.doFinal(input1)
          })
          .then((dataBlob: cryptoFramework.DataBlob): Promise<void> => {
            console.info("EncryptOutPut is " + dataBlob.data)
            AlertDialog.show({ message: "output" + dataBlob.data })
            cipherDataBlob = dataBlob
            // Initialize the Cipher instance and use the private key to decrypt the data.
            return decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, sm2KeyPair.priKey, null)
          })
          .then(() => {
            // Call doFinal() to decrypt data.
            return decoder.doFinal(cipherDataBlob)
          })
          .then(decodeData => {
            // Check whether the decrypted data is consistent with the original data.
            console.log(`DecryptOutPut is : ${this.Uint8ArrayToString(decodeData.data)}`)
            AlertDialog.show({message: this.Uint8ArrayToString(decodeData.data)})
            if (decodeData.data.toString() === input.data.toString()) {
              AlertDialog.show({ message: "decrypt success" })
              return
            }
            AlertDialog.show({ message: "decrypt fail" })
          })
      })
      .catch((e: Error) => {
        console.log(JSON.stringify(e))
      })
  }

  encryptMessagePromiseA(message: string) {
    // let privateKeyStr = "16A815B5558C1E816A70340D8CF56D92319D38393A7EE30EA188D8CC5F16CFB1"
    // let publicKeyStr  = "ED6EC968296E41AA61FBFD2ADAE6F0B3DDC21FF3F10DC0F206781B58334870B07121F08027B6D21350104EEFA677DCE58FB0BC5F063037A86D8380DFB66DAD46"
    // 64字节公钥数据
    let pk: cryptoFramework.Point = {
      x: BigInt("0xED6EC968296E41AA61FBFD2ADAE6F0B3DDC21FF3F10DC0F206781B58334870B0"),
      y: BigInt("0x7121F08027B6D21350104EEFA677DCE58FB0BC5F063037A86D8380DFB66DAD46")
    }
    // 32字节私钥数据
    let sk: bigint = BigInt("0x16A815B5558C1E816A70340D8CF56D92319D38393A7EE30EA188D8CC5F16CFB1")

    // // 64字节公钥数据
    // let pk: cryptoFramework.Point = {
    //   x: BigInt("0x5A033A9DBEF84C0784C897D070E6608C5AEED39B806DF82853D64E2A686A3794"),
    //   y: BigInt("0xF9233D20DD878F642D61C2B0344988AE284646226767A1631BBB0DBB6DF40D07")
    // }
    // // 32字节私钥数据
    // let sk: bigint = BigInt("0x3629EFF03FBC86711F6695CBF5590F0F2FCAAA3C269A1CA9BD64FB4C70DF9C9F")
    // 下面列出公钥、私钥和密钥对的参数模板，根据实际场景三选一
    // 公钥对象参数
    let pubKey: cryptoFramework.ECCPubKeySpec = {
      params: SM2.genSM2CommonSpec(),
      pk: pk,
      algName: "ECC",
      specType: cryptoFramework.AsyKeySpecType.PUBLIC_KEY_SPEC // 指定公钥类型
    }
    // 私钥对象参数
    let priKey: cryptoFramework.ECCPriKeySpec = {
      params: SM2.genSM2CommonSpec(),
      sk: sk,
      algName: "ECC",
      specType: cryptoFramework.AsyKeySpecType.PRIVATE_KEY_SPEC // 指定私钥类型
    }
    // 密钥对对象参数
    let keyPair: cryptoFramework.ECCKeyPairSpec = {
      params: SM2.genSM2CommonSpec(),
      sk: sk,
      pk: pk,
      algName: 'ECC',
      specType: cryptoFramework.AsyKeySpecType.KEY_PAIR_SPEC // 指定密钥对类型
    }

    // Create a Cipher instance for encryption.
    let cipher = cryptoFramework.createCipher("SM2_256|SM3")
    // Create a Cipher instance for decryption.
    let decoder = cryptoFramework.createCipher("SM2_256|SM3")

    let sm2KeyPair: cryptoFramework.KeyPair
    let cipherDataBlob: cryptoFramework.DataBlob
    let input: cryptoFramework.DataBlob = {data: SM2.textEncodeByUtf8(message)}

    let KeyPairGenerator: cryptoFramework.AsyKeyGeneratorBySpec
    KeyPairGenerator = cryptoFramework.createAsyKeyGeneratorBySpec(keyPair)
    KeyPairGenerator.generateKeyPair()
      .then((keyPair) => {
        // 获取公钥数据
        let pubKey = keyPair.pubKey
        let pubKeyArr: Uint8Array = pubKey.getEncoded().data
        let pubKeyBlob: cryptoFramework.DataBlob = { data: pubKeyArr }
        // 获取私钥数据
        let priKey = keyPair.priKey
        let priKeyArr: Uint8Array = priKey.getEncoded().data
        let priKeyBlob: cryptoFramework.DataBlob = { data: priKeyArr }
        // 传入公私钥数据生成密钥对象
        let generator = cryptoFramework.createAsyKeyGenerator("SM2_256")
        generator.convertKey(pubKeyBlob, priKeyBlob)
          .then(keyPair=>{
            sm2KeyPair = keyPair
            console.log("convert SM2 keyPair success")
            return cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, sm2KeyPair.pubKey, null)
          })
          .catch((err: BusinessError) => {
            console.log(JSON.stringify(err))
          })
          .then(() => {
            // doFinal
            let input1: cryptoFramework.DataBlob = {data: input.data}
            return cipher.doFinal(input1)
          })
          .then((dataBlob: cryptoFramework.DataBlob): Promise<void> => {
            console.info("EncryptOutPut is " + dataBlob.data)
            AlertDialog.show({ message: "output" + dataBlob.data })
            cipherDataBlob = dataBlob
            // Initialize the Cipher instance and use the private key to decrypt the data.
            return decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, sm2KeyPair.priKey, null)
          })
          .then(() => {
            // Call doFinal() to decrypt data.
            return decoder.doFinal(cipherDataBlob)
          })
          .then(decodeData => {
            // Check whether the decrypted data is consistent with the original data.
            console.log(`DecryptOutPut is : ${this.Uint8ArrayToString(decodeData.data)}`)
            AlertDialog.show({message: this.Uint8ArrayToString(decodeData.data)})
            if (decodeData.data.toString() === input.data.toString()) {
              AlertDialog.show({ message: "decrypt success" })
              return
            }
            AlertDialog.show({ message: "decrypt fail" })
          });
      })
      .catch((e: Error) => {
        console.log(JSON.stringify(e))
      })
  }

  // 以Promise方式加密
  encryptMessagePromise() {
    // Create an AsyKeyGenerator instance.
    let sm2Generator = cryptoFramework.createAsyKeyGenerator("SM2_256");
    // Create a Cipher instance.
    let cipher = cryptoFramework.createCipher("SM2_256|SM3");
    let hash = cipher.getCipherSpec(cryptoFramework.CipherSpecItem.SM2_MD_NAME_STR);
    console.info("SM2_MD_NAME_STR " + hash);
    // Generate an asymmetric key pair using the AsyKeyGenerator instance.
    let keyGenPromise = sm2Generator.generateKeyPair();
    keyGenPromise.then((sm2KeyPair: cryptoFramework.KeyPair): Promise<void> => {
      let pubKey = sm2KeyPair.pubKey;
      // Initialize the Cipher instance and use the public key to encrypt the message.
      return cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, pubKey, null);
    }).then(() => {
      // doFinal
      let input: cryptoFramework.DataBlob = { data: this.stringToUint8Array(plan) };
      return cipher.doFinal(input);
    }).then(dataBlob => {
      // Obtain the encrypted data.
      console.info("EncryptOutPut is " + dataBlob.data);
    })

    // 参数keyPair为ECC密钥对
    // async convertKey(keyPair: cryptoFramework.KeyPair){
    // // 获取公钥数据
    // let pubKey = keyPair.pubKey;
    // let pubKeyArr: Uint8Array = pubKey.getEncoded().data;
    // let pubKeyBlob: cryptoFramework.DataBlob = { data: pubKeyArr };
    // // 获取私钥数据
    // let priKey = keyPair.priKey;
    // let priKeyArr: Uint8Array = priKey.getEncoded().data;
    // let priKeyBlob: cryptoFramework.DataBlob = { data: priKeyArr };
    // // 传入公私钥数据生成密钥对象
    // let generator = cryptoFramework.createAsyKeyGenerator("SM2_256");
    // generator.convertKey(pubKeyBlob, priKeyBlob)
    //   .then(keyPair => {
    //     console.log("convert SM2 keyPair success")
    //   })
    //   .catch((err: BusinessError) => {
    //     console.log(JSON.stringify(e));
    //   })
    // }

  }

  // Encrypt the message in callback mode.
  encryptMessageCallback() {
    // Create an AsyKeyGenerator instance.
    let sm2Generator = cryptoFramework.createAsyKeyGenerator("SM2_256");
    // Create a Cipher instance.
    let cipher = cryptoFramework.createCipher("SM2_256|SM3");
    // Get Sm2 md name.
    let hash = cipher.getCipherSpec(cryptoFramework.CipherSpecItem.SM2_MD_NAME_STR);
    console.info("SM2_MD_NAME_STR " + hash);
    // Generate an asymmetric key pair using the AsyKeyGenerator instance.
    sm2Generator.generateKeyPair((err, keyPair) => {
      let pubKey = keyPair.pubKey;
      // Initialize the Cipher instance and use the public key to encrypt the message.
      cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, pubKey, null, (err, data) => {
        let input: cryptoFramework.DataBlob = { data: this.stringToUint8Array(plan) };
        // doFinal
        cipher.doFinal(input, (err, data) => {
          // Obtain the encrypted data.
          console.info("EncryptOutPut is " + data.data);
        })
      })
    })
  }

  // Encrypt and decrypt data in promise mode.
  decryptMessagePromise(message: string) {
    console.log(message)
    const base = new util.Base64Helper
    // Create an AsyKeyGenerator instance.
    let sm2Generator = cryptoFramework.createAsyKeyGenerator("SM2_256");
    // Create a Cipher instance for encryption.
    let cipher = cryptoFramework.createCipher("SM2_256|SM3");
    // Create a Cipher instance for decryption.
    let decoder = cryptoFramework.createCipher("SM2_256|SM3");
    // Generate an asymmetric key pair using the AsyKeyGenerator instance.
    // let keyGenPromise = sm2Generator.generateKeyPair();
    let privateKeyStr = "16A815B5558C1E816A70340D8CF56D92319D38393A7EE30EA188D8CC5F16CFB1"
    let publicKeyStr = "ED6EC968296E41AA61FBFD2ADAE6F0B3DDC21FF3F10DC0F206781B58334870B07121F08027B6D21350104EEFA677DCE58FB0BC5F063037A86D8380DFB66DAD46"
    let publicKey1: cryptoFramework.DataBlob = {data: base.decodeSync(publicKeyStr)}
    let privateKey1: cryptoFramework.DataBlob = {data: base.decodeSync(privateKeyStr)}
    let keyGenPromise = sm2Generator.convertKey(publicKey1, privateKey1)
    let keyPair: cryptoFramework.KeyPair;
    let cipherDataBlob: cryptoFramework.DataBlob;
    let input: cryptoFramework.DataBlob = { data: this.stringToUint8Array(message)};
    keyGenPromise.then( keyPair => {
      console.info("sm2 convertKey success.");
    }).catch((error: BusinessError) => {
      console.error("sm2 convertKey error.");
    });


    keyGenPromise.then((rsaKeyPair: cryptoFramework.KeyPair): Promise<void> => {
      keyPair = rsaKeyPair;
      // Initialize the Cipher instance and use the public key to encrypt the data.
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
        // Initialize the Cipher instance and use the private key to decrypt the data.
        return decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, keyPair.priKey, null);
      })
      .then(() => {
        // Call doFinal() to decrypt data.
        return decoder.doFinal(cipherDataBlob);
      })
      .then(decodeData => {
        // Check whether the decrypted data is consistent with the original data.
        console.log(`DecryptOutPut is : ${this.Uint8ArrayToString(decodeData.data)}`)
        AlertDialog.show({message: this.Uint8ArrayToString(decodeData.data)})
        if (decodeData.data.toString() === input.data.toString()) {
          AlertDialog.show({ message: "decrypt success" });
          return;
        }
        AlertDialog.show({ message: "decrypt fail" });
      });

  }

  // Encrypt and decrypt data in callback mode.
  decryptMessageCallback() {
    // Create an AsyKeyGenerator instance.
    let sm2Generator = cryptoFramework.createAsyKeyGenerator("SM2_256");
    // Create a Cipher instance for encryption.
    let cipher = cryptoFramework.createCipher("SM2_256|SM3");
    // Create a Cipher instance for decryption.
    let decoder = cryptoFramework.createCipher("SM2_256|SM3");
    let plainText = "this is cipher text";
    let input: cryptoFramework.DataBlob = { data: this.stringToUint8Array(plainText) };
    let cipherData: cryptoFramework.DataBlob;
    let keyPair: cryptoFramework.KeyPair;
    // Generate an asymmetric key pair using the AsyKeyGenerator instance.
    sm2Generator.generateKeyPair((err, newKeyPair) => {
      keyPair = newKeyPair;
      // Initialize the Cipher instance and use the public key to encrypt the data.
      cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, keyPair.pubKey, null, (err, data) => {
        // Call doFinal() to encrypt data.
        cipher.doFinal(input, (err, data) => {
          // Obtain the encrypted information and use it as the input parameter for decryption.
          AlertDialog.show({ message: "EncryptOutPut is " + data.data });
          cipherData = data;
          // Initialize the Cipher instance and use the private key to decrypt the data.
          decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, keyPair.priKey, null, (err, data) => {
            // Call doFinal() to decrypt data.
            decoder.doFinal(cipherData, (err, data) => {
              // Check whether the decrypted data is consistent with the original data.
              if (input.data.toString() === data.data.toString()) {
                AlertDialog.show({ message: "decrypt success" });
                return;
              }
              AlertDialog.show({ message: "decrypt fail" });
            });
          });
        });
      });
    });
  }
}
