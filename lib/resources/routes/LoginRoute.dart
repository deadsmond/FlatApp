import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import '../storages/PasswordStorage.dart';
import '../storages/ContentStorage.dart';
import 'NoteRoute.dart';
// import 'FingerprintRoute.dart';


//==============================================================================
//--------------------------- INITIALIZATION -----------------------------------
// FlatApp login view, operating application access point
class LoginRoute extends StatefulWidget {
  //---------------------------- VARIABLES -------------------------------------

  // password storage object - for validation purpose only
  final PasswordStorage passwordStorage;

  // content storage object - for emergency cleanup only
  final ContentStorage storageContent;

  LoginRoute({Key key,
    @required this.passwordStorage,
    @required this.storageContent
  }) : super(key: key);

  @override
  _LoginRouteState createState() => _LoginRouteState();
}

//==============================================================================
//---------------------------- WIDGET ------------------------------------------
class _LoginRouteState extends State<LoginRoute> {

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final _textController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    _textController.dispose();
    super.dispose();
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

  //---------------------------- MAIN ------------------------------------------
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
              controller: _textController,
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
              print("Attempted login");
              try {
                // check password from controller
                widget.passwordStorage.verify(_textController.text).then((check) {
                  // check for first entry
                  if (check == null){
                    print("first login noticed\ncleared note cache...");
                    // clear note file for security reasons
                    widget.storageContent.clear();
                    check = true;
                    _errorDialog();
                  }
                  if (check) {
                    print("Correct password, entry allowed.");
                    // go to note route
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        //builder: (buildContext) => FingerprintRoute(storageContent: widget.storageContent)
                        builder: (buildContext) => FlatApp(
                            passwordStorage: PasswordStorage(),
                            storageContent: ContentStorage()
                        )
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
                });
              } catch (e){
                // clear note file for security reasons
                print("Error during login. Cleared note cache...");
                widget.storageContent.clear();
                // what went wrong?
                print(e);
                // ask for new password
                _errorDialog();
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