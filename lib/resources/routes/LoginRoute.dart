import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import '../storages/PasswordStorage.dart';
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
  final myController = TextEditingController();

  // password storage object - for validation purpose only
  final PasswordStorage passwordStorage = PasswordStorage();

  //---------------------------- MAIN WIDGET -----------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlatApp: login page'),
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
              // exit app
              print("Exit app");
              break;
            case 1:
            // check password from controller
              print("Attempted login");

              if(passwordStorage.verify(myController.text)==true){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (buildContext) => FlatApp()
                    )
                );
              }else{
                  Flushbar(
                    title:  "Hey Ninja",
                    message:  "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
                    duration:  Duration(seconds: 3),
                  )..show(context);
              }
              break;
          }
        }
      ),
    );
  }
}