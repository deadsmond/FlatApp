import 'package:flutter/material.dart';

//==============================================================================
// FlatApp password view, operating password manipulation
class PasswordRoute extends StatefulWidget {
  @override
  _PasswordRouteState createState() => _PasswordRouteState();
}

class _PasswordRouteState extends State<PasswordRoute> {

  //---------------------------- VARIABLES -------------------------------------


  //---------------------------- MAIN WIDGET -----------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FlatApp: login page"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
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
                print("Save");
                break;
            }
          }
      ),
    );
  }
}