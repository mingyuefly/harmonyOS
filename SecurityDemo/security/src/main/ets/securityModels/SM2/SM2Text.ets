import hilog from '@ohos.hilog';
import { SM2_SEQUENCE } from './sm2Sequence';

export class ASN1Util {
  static BOOLEAN: string = "01";
  static INTEGER: string = "02";
  static BIT_STRING: string = "03";
  static OCTET_STRING: string = "04";
  static NULL: string = "05";
  static REAL: string = "09";
  static ENUMERATED: string = "0a";
  static SEQUENCE: string = "30";
  static SET: string = "31";
}

export class SM2_Ciphertext {
  /**
   * 用于将SM2裸密文数据序列化
   * @param primal_data SM2裸密钥数据，长度为96+明文长度（字节），输入格式为C1C3C2的Hex字符串
   * @returns 返回序列化后的标准密文数据，输出格式为Hex字符串
   */
  i2d_SM2_Ciphertext(primal_data: string): string {
    let sm2_sequence = new SM2_SEQUENCE();
    sm2_sequence.C1x = primal_data.slice(0, 64);
    primal_data = primal_data.slice(64, primal_data.length);
    sm2_sequence.C1y = primal_data.slice(0, 64);
    primal_data = primal_data.slice(64, primal_data.length);
    sm2_sequence.C3 = primal_data.slice(0, 64);
    primal_data = primal_data.slice(64, primal_data.length);
    sm2_sequence.C2 = primal_data;

    let C1x_title: string = (Number.parseInt("0x" + sm2_sequence.C1x.slice(0, 2)) > 127) ? "022100" : "0220";
    let C1y_title: string = (Number.parseInt("0x" + sm2_sequence.C1y.slice(0, 2)) > 127) ? "022100" : "0220";
    let C3_title: string = "0420";
    let C2_title: string = "04" + this.genLenHex(sm2_sequence.C2);
    let sequence_message: string = C1x_title + sm2_sequence.C1x + C1y_title + sm2_sequence.C1y + C3_title + sm2_sequence.C3 + C2_title + sm2_sequence.C2;
    let sequence_lenHex:string = this.genLenHex(sequence_message);

    let standard_data = "30" + sequence_lenHex + sequence_message;
    return standard_data;
  }

  /**
   * 用于将标准SM2密文数据解码
   * @param standard_data 标准SM2密文数据，符合ASN.1编码标准，输入格式为Hex字符串
   * @returns 返回ASN.1解码后的SM2密文数据
   */
  d2i_SM2_Ciphertext(standard_data: string): string {
    let message: string = standard_data;
    // 起始标识为03
    if (!message.startsWith(ASN1Util.SEQUENCE)) {
      this.ciphertextErr();
    }
    message = message.slice(ASN1Util.SEQUENCE.length, message.length);
    // SM2 sequence内容的长度
    let sequence_lenHex: string = this.getLenHex(message);
    message = message.slice(sequence_lenHex.length, message.length);
    let sequence_len: number = this.lenHex2number(sequence_lenHex);
    if (sequence_len != message.length / 2) {
      this.ciphertextErr();
    }

    let sm2_sequence = new SM2_SEQUENCE();
    message = this.readC1(sm2_sequence, message);
    message = this.readC3(sm2_sequence, message);
    message = this.readC2(sm2_sequence, message);
    // console.log(sm2_sequence.toString());

    let primal_data: string = sm2_sequence.C1x + sm2_sequence.C1y + sm2_sequence.C3 + sm2_sequence.C2;
    return primal_data;
  }

  // 生成传入内容的长度域
  genLenHex(content: string): string {
    let size: number = content.length / 2;
    let lenHex: string ;
    if (size.toString(16).length % 2 == 1 ) {
      lenHex= '0' + size.toString(16);
    }else {
      lenHex = size.toString(16);
    }
    if(size < 0x80){
      return lenHex;
    }
    let lenHex_size: number = lenHex.length / 2;
    return (lenHex_size | 0x80).toString(16) + lenHex;
  }

  // 提取长度域的Hex字符串
  getLenHex(data: string): string {
    let byte: number = Number.parseInt("0x" + data.slice(0, 2));
    let len_size: number = byte > 127 ? byte - 0x80 + 1 : 1;
    return data.slice(0, len_size * 2);
  }

  // 将长度域的Hex字符串转为整型
  lenHex2number(lenHex: string): number {
    if (lenHex.length == 2) {
      return Number.parseInt("0x" + lenHex);
    }
    return Number.parseInt("0x" + lenHex.slice(2, lenHex.length));
  }

  ciphertextErr() {
    hilog.error(0, "d2i_SM2_Ciphertext", "密文格式错误");
    throw new Error("SM2 ciphertext error!")
  }

  readC1(sm2_sequence: SM2_SEQUENCE, data: string): string {
    let xy: string[] = [];
    for (let i = 0; i < 2; i++) {
      if (data.startsWith("0220")) {
        xy[i] = data.slice(4, 68);
        data = data.slice(68, data.length);
      } else if (data.startsWith("022100")) {
        xy[i] = data.slice(6, 70);
        data = data.slice(70, data.length);
      } else {
        this.ciphertextErr();
      }
    }
    sm2_sequence.C1x = xy[0];
    sm2_sequence.C1y = xy[1];
    return data;
  }

  readC2(sm2_sequence: SM2_SEQUENCE, data: string): string {
    if (data.startsWith(ASN1Util.OCTET_STRING)) {
      data = data.slice(ASN1Util.OCTET_STRING.length, data.length);
      let C2_lenHex = this.getLenHex(data);
      data = data.slice(C2_lenHex.length, data.length)
      if (this.lenHex2number(C2_lenHex) != data.length / 2) {
        this.ciphertextErr()
      }
      sm2_sequence.C2 = data;
    } else {
      this.ciphertextErr();
    }
    return data;
  }

  readC3(sm2_sequence: SM2_SEQUENCE, data: string): string {
    if (data.startsWith("0420")) {
      sm2_sequence.C3 = data.slice(4, 68);
      data = data.slice(68, data.length);
    } else {
      this.ciphertextErr();
    }
    return data;
  }

}

