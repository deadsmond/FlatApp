import 'package:flutter/material.dart';


//==============================================================================
// FlatApp password view, operating password manipulation
class PasswordRoute extends StatelessWidget {

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
              icon: Icon(Icons.home),
              title: Text('Load'),
            ),
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
                print("Load");
                break;
              case 1:
                Navigator.pop(context);
                break;
              case 2:
                print("Save");
                break;
            }
          }
      ),
    );
  }
}