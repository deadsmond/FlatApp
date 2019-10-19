import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../storages/ContentStorage.dart';
import '../storages/PasswordStorage.dart';
import 'PasswordRoute.dart';
import 'package:flushbar/flushbar.dart';
import 'dart:async';
import 'dart:io';


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
  final textController = TextEditingController();

  //--------------------------- INITIALIZATION ---------------------------------
  // application init
  @override
  void initState() {
    super.initState();

    // REPAIR THIS SECTION - overuse of _loadContent causes app to crash
    // text field controller (move cursor to the first letter and do not allow
    // entering text)

    // set listeners to refresh app
    // textController.addListener(_loadContent);

    // load content to _content var
    //_loadContent();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the listeners.
    textController.dispose();
    super.dispose();
  }

  // change content var, but not file
  _changeContent() {
    setState(() {
      _content = textController.text;
    });
  }

  //-------------------------- FILE CONTENT ------------------------------------
  // load content from file
  Future<File> _loadContent(){
    try {
      storageContent.readContent().then((String value) {
          setState(() {
              _content = value;
              textController.text = _content;
            }
          );
        }
      );
    } catch (e){
      print("error during file loading\n$e");
    }
  }

  // save content to file
  Future<File> _saveContent() {
    // save to content var
    _changeContent();

    // save content to file
    return storageContent.writeContent(_content);
  }

  //---------------------------- MAIN WIDGET -----------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlatApp: note editor'),
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
              keyboardType: TextInputType.multiline,
              // add multiline textfield, with no max lines
              // (change null to value if needed)
              maxLines: null,
              controller: textController,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.file_download),
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
        ], // operate NavigationBar
        onTap: (index) {
          // operate NavigationBar
          switch (index) {
            case 0:
              _loadContent();
              Flushbar(
                title: "Loaded",
                message: "Content loaded successfully.",
                duration: Duration(seconds: 5),
              )
                ..show(context);
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PasswordRoute()),
              );
              break;
            case 2:
              _saveContent();
              Flushbar(
                title: "Saved",
                message: "Content saved successfully.",
                duration: Duration(seconds: 5),
              )
                ..show(context);
              break;
          }
        }
      ),
    );
  }
}
//==============================================================================
