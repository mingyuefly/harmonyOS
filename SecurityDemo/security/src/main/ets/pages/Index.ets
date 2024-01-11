import {AES} from '../securityModels/AES/AES'
import {RSA} from '../securityModels/RSA/RSA'
import {SM2} from '../securityModels/SM2/SM2'

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  private aesModel: AES = new AES()
  private rsaModel: RSA = new RSA()
  private sm2Model: SM2 = new SM2()
  aboutToAppear(): void {
    // aes
    // let arr = [1, 2];
    // let arr1 = new Uint8Array(arr);
    // arr = [3, 4];
    // let arr2 = new Uint8Array(arr);
    // let arr3 = this.aesModel.concatUint8Array(arr1, arr2);
    // console.log(`arr3 = ${arr3.toString()}`);

    // this.aesModel.aesEncrypt("在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。在进行对称加解密操作的时候，如果开发者对各个分组模式不够熟悉，建议对每次update和doFinal的结果都判断是否为null，并在结果不为null时取出其中的数据进行拼接，形成完整的密文/明文。这是因为选择的分组模式等各项规格都可能对update和doFinal结果产生影响。")
    // this.aesModel.aesEncrypt("message");
    // this.aesModel.aesEncrypt("aes message")
    // this.aesModel.aesEncrypt("aes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes messageaes message")
    // this.aesModel.aesEncrypt("加密内容")
    // this.aesModel.aesEncrypt("对称加解密中调用doFinal标志着一次加解密流程已经完成即Cipher实例的状态被清除因此当后续开启新一轮加解密流程时需要重新调用init()并传入完整的参数列表进行初始化")
    this.aesModel.aesEncrypt("对称加解密中，调用doFinal标志着一次加解密流程已经完成，即Cipher实例的状态被清除，因此当后续开启新一轮加解密流程时，需要重新调用init()并传入完整的参数列表进行初始化（比如即使是对同一个Cipher实例，采用同样的对称密钥，进行加密然后解密，则解密中调用init的时候仍需填写params参数，而不能直接省略为null）。如果遇到解密失败，需检查加解密数据和init时的参数是否匹配，包括GCM模式下加密得到的authTag是否填入解密时的GcmParamsSpec等。doFinal的结果可能为null，因此使用.data字段访问doFinal结果的具体数据前，请记得先判断结果是否为null，避免产生异常。RSA、SM2非对称加解密时多次doFinal操作的示例代码详见开发指导“使用加解密操作”。")

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



    // rsa
    // this.rsaModel.encryptMessagePromise()
    // this.rsaModel.decryptMessagePromise()

    // sm2
    // sm2Model.encryptMessagePromise()
    // this.sm2Model.decryptMessagePromise()
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