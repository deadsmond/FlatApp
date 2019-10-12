import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'resources/ContentStorage.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'FlatApp: read & write text',
      home: FlutterDemo(storage: ContentStorage()),
    ),
  );
}

//------------------------------------------------------------------------------

class FlutterDemo extends StatefulWidget {
  final ContentStorage storage;

  FlutterDemo({Key key, @required this.storage}) : super(key: key);

  @override
  _FlutterDemoState createState() => _FlutterDemoState();
}

//------------------------------------------------------------------------------

class _FlutterDemoState extends State<FlutterDemo> {

  // var to store text from notes
  String _content;

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  // index var - 0: Load, 1: Password, 2: Save
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // set listeners to refresh app
    myController.addListener(_loadContent);

    // load content to _content var
    _loadContent();
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

  // load content from file
  _loadContent(){
    widget.storage.readContent().then((String value) {
      setState(() {
        _content = value;
      });
    });
  }

  // save content to file
  Future<File> _saveContent() {
    // save to content var
    _changeContent();

    // save content to file
    return widget.storage.writeContent(_content);
  }

  // operate password - inactive
  void _changePassword(){

  }

  // operate NavigationBar
  void _onItemTapped(int index) {
    _selectedIndex = index;
    if (index == 0) {
      _loadContent();
      _alertDialog("Load");
    } else if (index == 1) {
      _changePassword();
      _alertDialog("Password operation");
    } else if (index == 2) {
      _saveContent();
      _alertDialog("Save");
    }
  }

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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
//==============================================================================
