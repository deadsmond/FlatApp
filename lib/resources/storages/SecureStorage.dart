import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart';


//==============================================================================
// Class containing password keys manipulation procedures
class SecureStorage{

  // Create storage
  final _storage = new FlutterSecureStorage();

  // Init vars
  final _iv = IV.fromLength(16);

  // plain text -> code
  String encrypt(String _text, String secret){
    final _encrypter = Encrypter(AES(Key.fromUtf8(secret.substring(0, 32))));
    return _encrypter.encrypt(_text, iv: _iv).base64;
  }

  // code -> plain text
  String decrypt(Encrypted _text, String secret) {
    final _encrypter = Encrypter(AES(Key.fromUtf8(secret.substring(0, 32))));
    return _encrypter.decrypt(_text, iv: _iv);
  }

  // Read key value - REPAIR - NEEDS TO RETURN STRING, NOT FUTURE STRING
  Future<String> readKey(key) async {
    try {
      // Read value
      return await _storage.read(key: key);

    } catch (e) {
      // If encountering an error, return 0
      return "error while getting key: $key";
    }
  }

  // Write value
  void write(key, value) async {
    await _storage.write(key: key, value: value);
  }
}
//==============================================================================
