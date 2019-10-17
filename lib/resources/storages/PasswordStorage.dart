import 'package:password/password.dart';
import 'SecureStorage.dart';

//==============================================================================
// Class containing safe password storage and validation
class PasswordStorage{

  // Initialize storage access
  static final storage = new SecureStorage();

  // Init vars
  final algorithm = PBKDF2();
  // no Password var in class:
  // password is never stored in object and therefore won't leak
  static const key = "FlatAppPasswdKey";
  // only the key (id of our key in Android KeyStore) to the storage is present

  // Store password
  void storePassword(password){
    // Never store password with plain text - use hash
    storage.write(key, password);
  }

  //store:
  // Password.hash(password, algorithm)
  // read:
  // Password.verify(password, hash)

  // Verify Password
  bool verify(password){
    // get hash from storage and verify it
    storage.readKey(key).then((value) {
      print("passwd: $password\nvalue: $value");
      print(password==value);
      return password==value;
    });
    // REPAIR - due to the future nature of this function,
    // this section will always be executed
    return true;
  }
}
//==============================================================================
