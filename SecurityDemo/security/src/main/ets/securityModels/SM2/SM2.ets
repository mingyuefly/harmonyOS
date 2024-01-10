import cryptoFramework from '@ohos.security.cryptoFramework';
import { BusinessError } from '@ohos.base';

let plan = "This is cipher test.";

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
    });
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
  decryptMessagePromise() {
    // Create an AsyKeyGenerator instance.
    let sm2Generator = cryptoFramework.createAsyKeyGenerator("SM2_256");
    // Create a Cipher instance for encryption.
    let cipher = cryptoFramework.createCipher("SM2_256|SM3");
    // Create a Cipher instance for decryption.
    let decoder = cryptoFramework.createCipher("SM2_256|SM3");
    // Generate an asymmetric key pair using the AsyKeyGenerator instance.
    let keyGenPromise = sm2Generator.generateKeyPair();
    let keyPair: cryptoFramework.KeyPair;
    let cipherDataBlob: cryptoFramework.DataBlob;
    let input: cryptoFramework.DataBlob = { data: this.stringToUint8Array(plan) };
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