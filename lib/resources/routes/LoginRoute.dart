import 'package:flutter/material.dart';


//==============================================================================
// FlatApp login view, operating application access point
class LoginRoute extends StatelessWidget {

  //---------------------------- VARIABLES -------------------------------------

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

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
          ],
          // operate NavigationBar
          onTap: (index) {
            // operate NavigationBar
            switch (index) {
              case 0:
              // check password from controller
                print("Attempted login");
                break;
            }
          }
      ),
    );
  }
}