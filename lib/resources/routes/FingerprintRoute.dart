import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import '../storages/FingerprintStorage.dart';
import '../storages/PasswordStorage.dart';
import '../storages/ContentStorage.dart';
import 'NoteRoute.dart';


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
                  _fingerprintStorage.authorizeAccess().then((check) {
                    if (check) {
                      print("Correct fingerprint, entry allowed.");
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
                  } catch (e) {
                    // clear note file for security reasons
                    print("Error during login. Cleared note cache...");
                    widget.storageContent.clear();
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