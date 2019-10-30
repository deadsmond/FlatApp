import 'package:local_auth/local_auth.dart';


//==============================================================================
// Class containing fingerprint manipulation procedures
class FingerprintStorage {

  //---------------------------- FINGERPRINT -----------------------------------
  Future<bool> verifyFingerprint() async {
    print("Attempted fingerprint login");
    try {
      var localAuth = new LocalAuthentication();
      bool auth = await localAuth.canCheckBiometrics;
      if(auth){
        auth = await localAuth.authenticateWithBiometrics(
          localizedReason: 'Please authenticate yourself',
          useErrorDialogs: true,
          stickyAuth: true,
        );
        if(auth){
          print("correct fingerprint");
          return true;
        }else{
          print("wrong fingerprint");
          return false;
        }
      }else{
        print("biometrics not supported");
        // allow access
        return true;
      }
      // check didAuthenticate and take action
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        // The device does not have fingerprint or Touch ID. Handle this error condition here.
        throw e;
      } else if (e.code == auth_error.passcodeNotSet) {
        // first login with fingerprint - erase note
        throw e;
      } else if (e.code == auth_error.notEnrolled) {
        // ? REPAIR
        throw e;
      }
    }
  }


  // 2. created object of localauthentication class
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  // 3. variable for track whether your device support local authentication means
  //    have fingerprint or face recognization sensor or not
  bool _hasFingerPrintSupport = false;
  // 4. we will set state whether user authorized or not
  String _authorizedOrNot = "Not Authorized";
  // 5. list of avalable biometric authentication supports of your device will be saved in this array
  List<BiometricType> _availableBuimetricType = List<BiometricType>();

  Future<void> _getBiometricsSupport() async {
    // 6. this method checks whether your device has biometric support or not
    bool hasFingerPrintSupport = false;
    try {
      hasFingerPrintSupport = await _localAuthentication.canCheckBiometrics;
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _hasFingerPrintSupport = hasFingerPrintSupport;
    });
  }

  Future<void> _getAvailableSupport() async {
    // 7. this method fetches all the available biometric supports of the device
    List<BiometricType> availableBuimetricType = List<BiometricType>();
    try {
      availableBuimetricType =
      await _localAuthentication.getAvailableBiometrics();
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _availableBuimetricType = availableBuimetricType;
    });
  }

  Future<void> _authenticateMe() async {
    // 8. this method opens a dialog for fingerprint authentication.
    //    we do not need to create a dialog nut it popsup from device natively.
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Authenticate for Testing", // message for dialog
        useErrorDialogs: true,// show error in dialog
        stickyAuth: true,// native process
      );
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _authorizedOrNot = authenticated ? "Authorized" : "Not Authorized";
    });
  }

  @override
  void initState() {
    _getBiometricsSupport();
    _getAvailableSupport();
    super.initState();
  }
}