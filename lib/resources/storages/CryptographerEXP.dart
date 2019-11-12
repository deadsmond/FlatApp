import 'package:encrypt/encrypt.dart';


//==============================================================================
// Class containing safe password storage and validation
class Cryptographer{

  // Init vars
  IV _iv;
  Encrypter _encrypter;

  Cryptographer(_key) {
    this._iv = IV.fromLength(16);
    this._encrypter = Encrypter(AES(Key.fromUtf8(_key)));
  }

  String encrypt(_text){
    return _encrypter.encrypt(_text, iv: _iv).toString();
  }

  // Store password
  String decrypt(_text) {
    return _encrypter.decrypt(_text, iv: _iv);
  }
}
//==============================================================================
