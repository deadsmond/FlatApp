import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import '../storages/PasswordStorage.dart';
import '../storages/ContentStorage.dart';
import 'NoteRoute.dart';


//==============================================================================
// FlatApp login view, operating application access point
class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {

  //---------------------------- VARIABLES -------------------------------------
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final textController = TextEditingController();

  // password storage object - for validation purpose only
  final PasswordStorage passwordStorage = PasswordStorage();

  // content storage object - for emergency cleanup only
  final ContentStorage storageContent = ContentStorage();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    textController.dispose();
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
              print("Attempted login");
              try {
                // check password from controller
                passwordStorage.verify(textController.text).then((check) {
                  // check for first entry
                  if (check == null){
                    print("first login noticed\ncleared note cache...");
                    // clear note file for security reasons
                    storageContent.clear();
                    check = true;
                  }
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
                });
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