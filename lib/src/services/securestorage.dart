import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService {
  late final FlutterSecureStorage storage;
  SecureStorageService() {
    // Create storage
    storage = const FlutterSecureStorage(
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
    // _checkFirstInstall();
  }

  // Future<void> _checkFirstInstall() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final isFirstInstall = !(prefs.getBool(installFlagKey) ?? false);

  //   if (isFirstInstall) {
  //     // App was freshly installed, clear any existing keychain data
  //     debugPrint('Fresh install detected, clearing keychain data');
  //     deleteAll();
  //     // Mark as installed
  //     await prefs.setBool(installFlagKey, true);
  //   }
  // }

  Future<String> getValueForKey(String keyName) async {
    // Read value
    debugPrint('getValueForKey $keyName');
    String value = await storage.read(key: keyName) ?? '';
    debugPrint('getValueForKey value $value');
    return value;
  }

  Future<void> saveValueForKey(String keyName, String keyValue) async {
    // Write value
    debugPrint('saveValueForKey $keyName $keyValue');
    await storage.write(key: keyName, value: keyValue);
  }

  Future<Map<String, String>> readAllValues() async {
    // Read all values
    Map<String, String> allValues = await storage.readAll();
    return allValues;
  }

  Future<void> deleteValueForKey(String keyName) async {
    // Delete value
    await storage.delete(key: keyName);
    debugPrint('deleteValueForKey $keyName ');
  }

  Future<void> deleteAll() async {
    // Delete all
    await storage.deleteAll();
  }
}
