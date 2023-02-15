import 'package:encrypt/encrypt.dart';

class CryptoTools {
  CryptoTools() {
    encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  }

  static late Encrypter encrypter;
  final Key key = Key.fromUtf8("&a=bZ-AXayakaehutaomainB-=a=#bXY");
  final IV iv = IV.fromLength(16);

  String encrypt(String data) {
    return encrypter.encrypt(data, iv: iv).base64;
  }

  String decrypt(String base64) {
    return encrypter.decrypt(
      Encrypted.from64(base64),
      iv: iv,
    );
  }
}
