import 'SecureStorage.dart';
import 'dart:async';


//==============================================================================
// class containing storage procedures
class ContentStorage {

  // Initialize storage access
  static final _storage = new SecureStorage();

  static const _key = "FlatAppContentKey";

  // read some data from the file
  Future<String> readContent() async {
    // get content from storage
    final contents = await _storage.readKey(_key);
    if(contents == null){
      // return empty object to raise the awareness
      return null;
    }else{
      return contents;
    }
  }

  // write some data to the file
  Future<void> writeContent(String content) async {
    try {
      _storage.write(_key, content);
    } catch (e) {
      // If encountering an error, return error
      print("error occurred during writing content in Content Storage");
      return e;
    }
  }

  // clear file content - separate function for cleaner flow
  Future<void> clear() async {
    try {
      writeContent('');
    } catch (e) {
      // If encountering an error, return error
      return e;
    }
  }
}
//==============================================================================
