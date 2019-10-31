import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';


//==============================================================================
// Class containing fingerprint manipulation procedures
class FingerprintStorage {
  //---------------------------- VARIABLES -------------------------------------
  final _auth = LocalAuthentication();

  //---------------------------- FINGERPRINT ---------------------------------
  Future<bool> getBiometricsSupport() async {
    try {
      bool _hasFingerPrintSupport = await _auth.canCheckBiometrics;
      return _hasFingerPrintSupport;
    } catch (e) {
      throw e;
    }
  }

  Future<List> getAvailableSupport() async {
    // 7. this method fetches all the available biometric supports of the device
    List<BiometricType> availableBiometricType = List<BiometricType>();
    try {
      availableBiometricType = await _auth.getAvailableBiometrics();
      return availableBiometricType;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> authorizeAccess() async {
    print("Attempted fingerprint login");
    try {
      bool _hasFingerPrintSupport = false;
      getBiometricsSupport().then((value){
        _hasFingerPrintSupport = value;
      });
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