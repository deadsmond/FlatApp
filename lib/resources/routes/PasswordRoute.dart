import 'package:flutter/material.dart';
import '../storages/PasswordStorage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';

//==============================================================================
// FlatApp password view, operating password manipulation
class PasswordRoute extends StatefulWidget {
  //---------------------------- VARIABLES -------------------------------------

  // password storage object
  final PasswordStorage passwordStorage;

  PasswordRoute({Key key,
    @required this.passwordStorage
  }) : super(key: key);

  @override
  _PasswordRouteState createState() => _PasswordRouteState();
}

class _PasswordRouteState extends State<PasswordRoute> {

  //---------------------------- VARIABLES -------------------------------------
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final textControllerOld = TextEditingController();
  final textControllerNew = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    textControllerOld.dispose();
    textControllerNew.dispose();
    super.dispose();
  }

  //---------------------------- MAIN WIDGET -----------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FlatApp: password page"),
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
              'Please enter old password:',
            ),
            TextField(
              controller: textControllerOld,
              // hide text input (replace it with dots)
              obscureText: true,
            ),
            Text(
              'Please enter new password:',
            ),
            TextField(
              controller: textControllerNew,
              // hide text input (replace it with dots)
              obscureText: true,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.note),
              title: Text('Note'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.save),
              title: Text('Save'),
            ),
          ],
          onTap: (index) {
            // operate NavigationBar
            switch (index) {
              case 0:
                Navigator.pop(context);
                break;
              case 1:
                print("verifying password...");
                widget.passwordStorage.verify(textControllerOld.text).then((check) {
                  // check for first entry
                  if (check == null){
                    print("first login noticed");
                    check = true;
                  }
                  if (check) {
                    print("Saving new password...");
                    widget.passwordStorage.storePassword(textControllerNew.text);
                    print("Password saved.");
                    Flushbar(
                      title: "Success",
                      message: "New password saved",
                      duration: Duration(seconds: 5),
                    )
                      ..show(context);
                  }else{
                    print("Password didn't match.");
                    Flushbar(
                      title: "Failed to change password",
                      message: "Old password is not correct.",
                      duration: Duration(seconds: 5),
                    )
                      ..show(context);
                  }
                });
                break;
            }
          }
      ),
    );
  }
}