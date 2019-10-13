import 'package:flutter/material.dart';
import 'resources/storages/ContentStorage.dart';
import 'resources/storages/PasswordStorage.dart';
import 'resources/FlatApp.dart';


// main app init
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlatApp: read & write text',
      home: FlatApp(
          storageContent: ContentStorage(),
          storagePassword: PasswordStorage()
      ),
    ),
  );
}
