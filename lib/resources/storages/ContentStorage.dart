import 'package:path_provider/path_provider.dart';
// import 'CryptographerEXP.dart';
import 'dart:async';
import 'dart:io';

//==============================================================================
// class containing file manipulation procedures
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
      return "error while reading note";
    }
  }

  // write some data to the file
  Future<File> writeContent(String content) async {
    try {
      final file = await _localFile;
      // Write the file
      return file.writeAsString('$content');
    } catch (e) {
      // If encountering an error, return error
      print("error occurred during writing content in Content Storage");
      return e;
    }
  }

  // clear file content - separate function for cleaner flow
  Future<File> clear() async {
    try {
      final file = await _localFile;
      // Write the file
      return file.writeAsString('');
    } catch (e) {
      // If encountering an error, return error
      return e;
    }
  }
}
//==============================================================================
