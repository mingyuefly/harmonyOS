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
    // this.aesModel.aesEncrypt("message")

    // rsa
    // this.rsaModel.encryptMessagePromise()
    // this.rsaModel.decryptMessagePromise()

    // sm2
    // sm2Model.encryptMessagePromise()
    this.sm2Model.decryptMessagePromise()
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