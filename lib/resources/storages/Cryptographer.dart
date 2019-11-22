import 'package:encrypt/encrypt.dart';


//==============================================================================
// Class containing safe password storage and validation
class Cryptographer{

  // Init vars
  IV _iv;
  Encrypter _encrypter;

  // key is optional in constructor
  // due to the emergency route with no key provided
  Cryptographer([_key]) {
    this._iv = IV.fromLength(16);

    // make sure key is 32 chars long
    if(_key != Null){
      _key = _key + '.' * (32 - _key.length);
    } else {
      _key = '.' * 32;
    }

    this._encrypter = Encrypter(AES(Key.fromUtf8(_key)));
  }

  // plain text -> code
  String encrypt(_text){
    return _encrypter.encrypt(_text, iv: _iv).toString();
  }

  // code -> plain text
  String decrypt(Encrypted _text) {
    return _encrypter.decrypt(_text, iv: _iv);
  }
}
//==============================================================================
