import 'package:flutter_secure_storage/flutter_secure_storage.dart';


//==============================================================================
// Class containing password keys manipulation procedures
class SecureStorage{

  // Create storage
  final storage = new FlutterSecureStorage();

  // Read key value - REPAIR - NEEDS TO RETURN STRING, NOT FUTURE STRING
  Future<String> readKey(key) async {
    try {
      // Read value
      String value = await storage.read(key: key);
      return value;

    } catch (e) {
      // If encountering an error, return 0
      return "error while getting key: $key";
    }
  }

  // Read all values
  Future<Map> readAll(key) async {
    try {
      // Read value
      Map<String, String> allValues = await storage.readAll();
      return allValues;

    } catch (e) {
      // If encountering an error, return 0
      return {'error': '-1'};
    }
  }

  // Delete value
  void deleteKey(key) async {
    await storage.delete(key: key);
  }

  // Delete all
  void deleteAll() async {
    await storage.deleteAll();
  }

  // Write value
  void write(key, value) async {
    await storage.write(key: key, value: value);
  }
}
//==============================================================================
