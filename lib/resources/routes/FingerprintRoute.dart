import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import '../storages/PasswordStorage.dart';
import '../storages/ContentStorage.dart';
import 'package:local_auth/local_auth.dart';
import 'NoteRoute.dart';


//==============================================================================
// FlatApp login view, operating application access point
class FingerprintRoute extends StatefulWidget {
  @override
  _FingerprintRouteState createState() => _FingerprintRouteState();
}

class _FingerprintRouteState extends State<FingerprintRoute> {

  //---------------------------- VARIABLES -------------------------------------
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final textController = TextEditingController();

  // content storage object - for emergency cleanup only
  final ContentStorage storageContent = ContentStorage();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    textController.dispose();
    super.dispose();
  }


  Future<bool> verifyFingerprint() async {
    print("Attempted fingerprint login");
    try {
      var localAuth = new LocalAuthentication();
      bool auth = await localAuth.canCheckBiometrics;
      if(auth){
        auth = await localAuth.authenticateWithBiometrics(
            localizedReason: 'Please authenticate yourself');
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
        // clear note file for security reasons
        storageContent.clear();
        return true;
      } else if (e.code == auth_error.passcodeNotSet) {
        // first login with fingerprint - erase note
        // clear note file for security reasons
        storageContent.clear();
        return true;
      } else if (e.code == auth_error.notEnrolled) {
        // ? REPAIR
        // clear note file for security reasons
        storageContent.clear();
        return true;
      }
    }
  }

  //---------------------------- DIALOG ----------------------------------------
  Future<void> _errorDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set up new password'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Error during password loading occured. '
                        'Note content has been erased for security reasons. '
                        'Please set up new password in "Password" section.'
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //---------------------------- MAIN WIDGET -----------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlatApp: login page'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () =>
                SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              'Please enter password:',
            ),
            TextField(
              controller: textController,
              // hide text input (replace it with dots)
              obscureText: true,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.not_interested),
              title: Text('Exit'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.exit_to_app),
              title: Text('Login'),
            ),
          ],
          // operate NavigationBar
          onTap: (index) {
            // operate NavigationBar
            switch (index) {
              case 0:
              // exit app - this is preferred way
              //https://api.flutter.dev/flutter/services/SystemNavigator/pop.html
                print("Exit app");
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                break;
              case 1:
                bool check = verifyFingerprint();
                try {
                  if (check) {
                    print("Correct password, entry allowed.");
                    // go to note route
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (buildContext) => FlatApp()
                        )
                    );
                  } else {
                    print("Wrong password, entry denied.");
                    Flushbar(
                      title: "Error",
                      message: "Wrong password. Please try again.",
                      duration: Duration(seconds: 5),
                    )
                      ..show(context);
                  }
                } catch (e){
                  // clear note file for security reasons
                  print("Error during login. Cleared note cache...");
                  storageContent.clear();
                  // what went wrong?
                  print(e);
                  // ask for new password
                  _errorDialog();
                  // go to note route
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (buildContext) => FlatApp()
                      )
                  );
                }
                break;
            }
          }
      ),
    );
  }
}