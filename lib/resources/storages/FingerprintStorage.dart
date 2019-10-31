import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';


//==============================================================================
// Class containing fingerprint manipulation procedures
class FingerprintStorage {
  //---------------------------- VARIABLES -------------------------------------
  // local auth object to control access methods
  final _auth = LocalAuthentication();

  //---------------------------- FINGERPRINT -----------------------------------
  // Check if biometrics are supported
  Future<bool> getBiometricsSupport() async {
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
      return availableBiometricType;
    } catch (e) {
      throw e;
    }
  }

  // main authorization
  Future<bool> authorizeAccess() async {
    print("Attempted fingerprint login");
    try {
      bool _hasFingerPrintSupport = await getBiometricsSupport();
      if(_hasFingerPrintSupport){
          // this method opens a dialog for fingerprint authentication.
          // we do not need to create a dialog nut it popup from device natively.
          bool temp = await _auth.authenticateWithBiometrics(
            localizedReason: 'Please authenticate yourself',
            useErrorDialogs: true,
            stickyAuth: true,
          );
        if(temp){
          print("correct fingerprint");
          return true;
        }else{
          print("wrong fingerprint");
          return false;
        }
      }else{
        print("biometrics not supported");
        return false;
      }
      // check didAuthenticate and take action
    } on PlatformException catch (e) {
      throw e;
    }
  }
}