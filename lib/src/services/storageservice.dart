import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  FlutterSecureStorage? storage;

  StorageService() {
    storage = const FlutterSecureStorage();
  }

  void save(String keyname, String value) async {
    // Write value
    await storage?.write(key: keyname, value: value);
  }

  Future<String> getValue(String keyname) async {
    // Read value
    String storedValue = (await storage?.read(key: keyname) == null)
        ? ''
        : await storage?.read(key: keyname) as String;
    return storedValue;
  }

  void delete(String keyname) async {
    // Delete value
    await storage?.delete(key: keyname);
  }

  void deleteAll() async {
    // Delete All
    await storage?.deleteAll();
  }
}
