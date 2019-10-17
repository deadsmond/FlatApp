import 'package:flutter/material.dart';
import '../storages/PasswordStorage.dart';
import 'package:flushbar/flushbar.dart';

//==============================================================================
// FlatApp password view, operating password manipulation
class PasswordRoute extends StatefulWidget {
  @override
  _PasswordRouteState createState() => _PasswordRouteState();
}

class _PasswordRouteState extends State<PasswordRoute> {

  //---------------------------- VARIABLES -------------------------------------
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  // password storage object
  PasswordStorage passwordStorage = PasswordStorage();

  //---------------------------- MAIN WIDGET -----------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FlatApp: password page"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(null),
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
              controller: myController,
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
                print("Saving new password...");
                passwordStorage.storePassword(myController.text);
                print("Password saved.");
                Flushbar(
                  title: "Success",
                  message: "New password saved",
                  duration: Duration(seconds: 3),
                )
                  ..show(context);
                break;
            }
          }
      ),
    );
  }
}