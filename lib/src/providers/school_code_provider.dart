import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:myschooly/src/services/apiservice.dart';
import 'package:myschooly/src/utils/constants.dart';
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
      if (status == 'success' && target != null && target.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('target_url', target);
        debugPrint('Saved target_url: $target');
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
