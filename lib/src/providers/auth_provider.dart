import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myschooly/src/services/apiservice.dart';
import 'package:myschooly/src/utils/constants.dart';

class AuthProvider with ChangeNotifier {
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? profile;
  String? token;

  Future<void> login(String username, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final base = prefs.getString('target_url') ?? ApiConstants.baseUrl;
      final api = ApiService(baseOverride: base);
      final res = await api.postForm('/api/mobile/login', {
        'login': username,
        'password': password,
      });
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final status = data['status']?.toString();
      if (status == 'success') {
        token = data['token']?.toString();
        profile = data['profile'] is Map<String, dynamic> ? (data['profile'] as Map<String, dynamic>) : null;
        if (token != null) {
          await prefs.setString('auth_token', token!);
        }
      } else {
        error = data['message']?.toString() ?? 'Login failed';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
