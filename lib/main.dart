import 'package:flutter/material.dart';
import 'resources/routes/LoginRoute.dart';


// main app init
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlatApp: read & write text',
      home: LoginRoute(),
    ),
  );
}
