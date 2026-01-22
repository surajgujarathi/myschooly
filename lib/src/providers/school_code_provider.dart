import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:myschooly/src/services/apiservice.dart';
import 'package:myschooly/src/services/apiconstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchoolCodeProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? result;

  Future<void> verifyCode(String code) async {
    isLoading = true;
    error = null;
    result = null;
    notifyListeners();
    try {
      final res = await _api.postForm(ApiConstants.verifyCodePath, {
        'secure_code': code,
      });
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final status = data['status']?.toString();
      final target = data['target_url']?.toString();
      final dbName = data['db']?.toString(); // Assuming the key is 'db'

      if (status == 'success') {
        final prefs = await SharedPreferences.getInstance();
        if (target != null && target.isNotEmpty) {
          await prefs.setString('target_url', target);
          debugPrint('Saved target_url: $target');
        }
        if (dbName != null && dbName.isNotEmpty) {
          await prefs.setString('school_db_name', dbName);
          debugPrint('Saved school_db_name: $dbName');
        }
      }
      result = data;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
