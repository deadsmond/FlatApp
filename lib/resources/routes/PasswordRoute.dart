import 'package:flutter/material.dart';


class PasswordRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}