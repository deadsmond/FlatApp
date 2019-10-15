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
  final myController = TextEditingController();

  // password storage object - for validation purpose only
  final PasswordStorage passwordStorage = PasswordStorage();

  // content storage object - for emergency cleanup only
  final ContentStorage storageContent = ContentStorage();

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
                print(passwordStorage.verify(myController.text));
                if (passwordStorage.verify(myController.text) == true) {
                  // go to note route
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (buildContext) => FlatApp()
                      )
                  );
                } else {
                  Flushbar(
                    title: "Error",
                    message: "Wrong password. Please try again.",
                    duration: Duration(seconds: 3),
                  )
                    ..show(context);
                }
              } catch (e){
                // no password found:
                // clear note file for security reasons
                print("Error during login. Cleared note cache...");
                storageContent.writeContent("");

                // what went wrong?
                print(e);

                // ask for new password - REPAIR

                // go to note route - REPAIR
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