import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:flutter/services.dart';


//==============================================================================
// Class containing fingerprint manipulation procedures
class FingerprintStorage {
  //---------------------------- VARIABLES -------------------------------------
  // local auth object to control access methods
  final _auth = LocalAuthentication();

  //---------------------------- FINGERPRINT -----------------------------------
  // Check if biometrics are supported
  Future<bool> _getBiometricsSupport() async {
    try {
      bool _hasFingerPrintSupport = await _auth.canCheckBiometrics;
      return _hasFingerPrintSupport;
    } catch (e) {
      throw e;
    }
  }

  // Method to fetch all the available biometric supports of the device.
  // Currently unused.
  Future<List> getAvailableSupport() async {
    List<BiometricType> availableBiometricType = List<BiometricType>();
    try {
      availableBiometricType = await _auth.getAvailableBiometrics();
      return availableBiometricType; // [BiometricType.fingerprint]
    } catch (e) {
      throw e;
    }
  }

  Future<bool> _authenticateFingerprint() async {
    print("finger check");
    bool check;
    check = await _auth.authenticateWithBiometrics(
      localizedReason: 'Please authenticate yourself',
      useErrorDialogs: true,
      stickyAuth: true,
    );
    return check;
  }

  // main authorization
  bool authorizeAccess() {
    print("Attempted fingerprint login");
    try {
      _getBiometricsSupport().then((check){
        if(check){
          print("scan");
          // this method opens a dialog for fingerprint authentication.
          // we do not need to create a dialog but it popup from device natively.
          _authenticateFingerprint().then((check){
              print("hmmm");
              print(check);
              if(check){
                print("correct fingerprint");
                return true;
              }else{
                print("wrong fingerprint");
                return false;
              }
            }
          );
          print("workflow error 1");
          return false;
        }else{
          print("biometrics not supported");
          return false;
        }
      });
      print("workflow error 2");
      return false;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        // The device does not have fingerprint or Touch ID
        print("fingerprint is not supported");
      } else if (e.code == auth_error.passcodeNotSet) {
        print("no fingerprint is set as correct");
      } else if (e.code == auth_error.notEnrolled) {
        print("notEnrolled");
      } else if (e.code == auth_error.notAvailable) {
        print("notAvailable");
      } else if (e.code == auth_error.otherOperatingSystem) {
        print("otherOperatingSystem");
      }
      return false;
    }
  }
}