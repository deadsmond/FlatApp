import '../storages/PasswordStorage.dart';
import '../storages/ContentStorage.dart';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  final _textControllerOld = TextEditingController();
  final _textControllerNew = TextEditingController();

  ContentStorage _storage = ContentStorage();
  int _radioValue = 0;

  @override
  void initState() {
    super.initState();
    updateRadio();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    _textControllerOld.dispose();
    _textControllerNew.dispose();
    super.dispose();
  }

  void updateRadio(){
    _storage.readContent('authentication').then((_choice){
      setState(() {
        if(_choice == 'password'){
          _radioValue = 1;
        }else if(_choice == 'fingerprint'){
          _radioValue = 2;
        }
      });
    });
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 1:
          _storage.writeContent('authentication', 'password');
          print(_storage.readContent('authentication'));
          Fluttertoast.showToast(msg: 'Set authentication to password',
              toastLength: Toast.LENGTH_SHORT);
          break;
        case 2:
          ContentStorage _storage = ContentStorage();
          _storage.writeContent('authentication', 'fingerprint');
          Fluttertoast.showToast(msg: 'Set authentication to fingerprint',
              toastLength: Toast.LENGTH_SHORT);
          break;
      }
    });
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
              controller: _textControllerOld,
              // hide text input (replace it with dots)
              obscureText: true,
            ),
            Text(
              'Please enter new password:',
            ),
            TextField(
              controller: _textControllerNew,
              // hide text input (replace it with dots)
              obscureText: true,
            ),
              new Radio(
                value: 1,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              new Text(
                'Password',
                style: new TextStyle(
                  fontSize: 16.0,
                ),
              ),
              new Radio(
                value: 2,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              new Text(
                'Fingerprint',
                style: new TextStyle(fontSize: 16.0),
              ),
            ],
          ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.note),
              title: Text('Back to Note'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.save),
              title: Text('Save password'),
            ),
          ],
          onTap: (index) {
            // operate NavigationBar
            switch (index) {
              case 0:
                // NOTE ROUTE --------------------------------------------------
                Navigator.pop(context);
                break;
              case 1:
                // CHANGE PASSWORD ---------------------------------------------
                print("verifying password...");
                widget.passwordStorage.verify(
                    _textControllerOld.text).then((check) {
                  // check for first entry
                  if (check == null){
                    print("first login noticed");
                    check = true;
                  }
                  if (check) {
                    print("Saving new password...");
                    widget.passwordStorage.storePassword(
                        _textControllerNew.text);
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
            // -----------------------------------------------------------------
            }
          }
      ),
    );
  }
}