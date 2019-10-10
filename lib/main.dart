import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'FlatApp: read & write text',
      home: FlutterDemo(storage: ContentStorage()),
    ),
  );
}

//==============================================================================

class ContentStorage {

    /*
    The path_provider plugin provides a platform-agnostic way
    to access commonly used locations on the device’s file system.
    The plugin currently supports access to two file system locations:

    Temporary directory: A temporary directory (cache) that the system can
    clear at any time. On iOS, this corresponds to the NSCachesDirectory.
    On Android, this is the value that getCacheDir() returns.

    Documents directory: A directory for the app to store files that only it
    can access. The system clears the directory only when the app is deleted.
    On iOS, this corresponds to the NSDocumentDirectory.
    On Android, this is the AppData directory.
   */

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // create a reference to the file’s full location,
  // using the File class from the dart:io library

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/note.txt');
  }

  // read some data from the file
  Future<String> readContent() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "error";
    }
  }

  // write some data to the file
  Future<File> writeContent(String content) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$content');
  }
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
  String _content;

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // change content when changing text input
    myController.addListener(_changeContent);

    // load content to _content var
    _loadContent();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
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
    return widget.storage.writeContent(_content);
  }

  // operate password - inactive
  void _changePassword(){

  }

  // operate NavigationBar
  int _selectedIndex = 0;
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
