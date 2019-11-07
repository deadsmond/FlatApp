import 'package:password/password.dart';
import 'SecureStorage.dart';


//==============================================================================
// Class containing safe password storage and validation
class PasswordStorage{

  // Initialize storage access
  static final _storage = new SecureStorage();

  // Init vars
  final _algorithm = PBKDF2();
  // no Password var in class:
  // password is never stored in object and therefore won't leak
  static const _key = "FlatAppPasswdKey";
  // only the key (id of our key in Android KeyStore) to the storage is present

  // Store password
  void storePassword(password) async {
    // Never store password with plain text - use hash
    _storage.write(_key, Password.hash(password, _algorithm));
  }

  // Verify Password
  Future<bool> verify(password) async {
    // get hash from storage and verify it
    final hash = await _storage.readKey(_key);
    // if it is first check (no password applied)
    if(hash == null){
      // return empty object to raise the awareness
      return null;
    }else{
      return Password.verify(password, hash);
    }
  }
}
//==============================================================================
