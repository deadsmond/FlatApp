import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import '../storages/FingerprintStorage.dart';
import '../storages/PasswordStorage.dart';
import '../storages/ContentStorage.dart';
import 'NoteRoute.dart';
import 'package:flutter_android/android_app.dart';


//==============================================================================
//--------------------------- INITIALIZATION -----------------------------------
// FlatApp login view, operating application access point
class FingerprintRoute extends StatefulWidget {
  //---------------------------- VARIABLES -------------------------------------

  // content storage object - for emergency cleanup only
  final ContentStorage storageContent;

  FingerprintRoute({Key key,
    @required this.storageContent
  }) : super(key: key);

  @override
  _FingerprintRouteState createState() => _FingerprintRouteState();
}

//==============================================================================
//---------------------------- WIDGET ------------------------------------------
class _FingerprintRouteState extends State<FingerprintRoute> {

  //---------------------------- VARIABLES -------------------------------------
  final FingerprintStorage _fingerprintStorage = FingerprintStorage();

  // TODO check methods
  // https://developer.android.com/reference/android/app/KeyguardManager
  // https://pub.dev/documentation/flutter_android/latest/
  // https://pub.dev/documentation/flutter_android/latest/android_app/KeyguardManager-class.html
  KeyguardManager _keyguard = KeyguardManager();

  //---------------------------- MAIN WIDGET -----------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlatApp: fingerprint page'),
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
              'Please provide fingerprint.',
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
                // check password from controller
                try {
                  // _keyguard. TODO KeyguardManager
                  widget.storageContent.readContent('authentication').then((_value) {
                    if(_value == 'fingerprint'){
                      print("trying fingerprint...");
                      _fingerprintStorage.authorizeAccess().then((_check){
                        if(_check){
                          print("Correct fingerprint, entry allowed.");
                          // go to note route
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (buildContext) => FlatApp(
                                      passwordStorage: PasswordStorage(),
                                      storageContent: widget.storageContent
                                  )
                              )
                          );
                        } else {
                          print("Wrong fingerprint, entry denied.");
                          Flushbar(
                            title: "Error",
                            message: "Wrong fingerprint. Please try again.",
                            duration: Duration(seconds: 5),
                          )
                            ..show(context);
                        }
                      });
                    }else{
                      if(_value == 'password') {
                        print('Password is set as authentication');
                      }else{
                        // clear note file for security reasons
                        print("Error during login. Cleared note cache...");
                        widget.storageContent.clear('note_content');
                      }
                      // go to note route
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (buildContext) => FlatApp(
                                  passwordStorage: PasswordStorage(),
                                  storageContent: ContentStorage()
                              )
                          )
                      );
                    }
                  });
                } catch (e) {
                  // clear note file for security reasons
                  print("Error during fingerprint scan. "
                      "Cleared note cache...");
                  widget.storageContent.clear('note_content');
                  // what went wrong?
                  print(e);
                  // go to note route
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (buildContext) => FlatApp(
                        passwordStorage: PasswordStorage(),
                        storageContent: ContentStorage()
                      )
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