import 'package:password/password.dart';
import 'SecureStorage.dart';

//==============================================================================
// Class containing safe password storage and validation
class PasswordStorage{

  // Initialize storage access
  final storage = new SecureStorage();

  // Init vars
  final algorithm = PBKDF2();
  // no Password var in class:
  // password is never stored in object and therefore won't leak
  final key = "FlatAppPasswdKey";
  // only the key (id of our key in Android KeyStore) to the storage is present

  // Store password
  void storePassword(password){
    // Never store password with plain text - use hash
    storage.write(key, Password.hash(password, algorithm));
  }

  // Verify Password
  bool verify(password){
    // get hash from storage and verify it
    return Password.verify(password, storage.readKey(key).toString());
  }
}
//==============================================================================
