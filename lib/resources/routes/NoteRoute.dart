import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../storages/ContentStorage.dart';
import '../storages/PasswordStorage.dart';
import 'PasswordRoute.dart';


//==============================================================================
// FlatApp class object, operating algorithms and behaviour
class FlatApp extends StatefulWidget {
  @override
  _FlatAppMainState createState() => _FlatAppMainState();
}

//==============================================================================
class _FlatAppMainState extends State<FlatApp> {

  //---------------------------- VARIABLES -------------------------------------

  ContentStorage storageContent;
  PasswordStorage storagePassword;

  // var to store text from notes
  String _content;

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  //--------------------------- INITIALIZATION ---------------------------------
  // application init
  @override
  void initState() {
    super.initState();

    // REPAIR THIS SECTION - overuse of _loadContent causes app to crash
    // text field controller (move cursor to the first letter and do not allow
    // entering text)

    // set listeners to refresh app
    //myController.addListener(_loadContent);

    // load content to _content var
    //_loadContent();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the listeners.
    myController.dispose();
    super.dispose();
  }

  // change content var, but not file
  _changeContent() {
    setState(() {
      _content = myController.text;
    });
  }

  //-------------------------- FILE CONTENT ------------------------------------
  // load content from file
  _loadContent(){
    storageContent.readContent().then((String value) {
      setState(() {
        _content = value;
        myController.text = _content;
      });
    });
  }

  // save content to file
  Future<File> _saveContent() {
    // save to content var
    _changeContent();

    // save content to file
    return storageContent.writeContent(_content);
  }

  //-------------------------- FRONT VIEW OF APP -------------------------------
  Future<void> _alertDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Action completed'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('$message completed'),
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
        title: Text('FlatApp: note editor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              'Note content:',
            ),
            Text(
              '$_content',
              softWrap: true,
            ),
            Text(
              'Edit note:',
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
            icon: Icon(Icons.home),
            title: Text('Load'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            title: Text('Password'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.save),
            title: Text('Save'),
          ),
        ],
          // operate NavigationBar
        onTap: (index) {
          // operate NavigationBar
          switch (index) {
            case 0:
              _loadContent();
              _alertDialog("Load");
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PasswordRoute()),
              );
              break;
            case 2:
              _saveContent();
              _alertDialog("Save");
              break;
          }
        }
      ),
    );
  }
}
//==============================================================================
