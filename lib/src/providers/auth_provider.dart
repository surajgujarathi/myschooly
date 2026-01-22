import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myschooly/src/services/apiservice.dart';
import 'package:myschooly/src/services/apiconstants.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? profile;
  String? token;
  String? userRole;
  bool isInitialized = false;

  bool get isAuthenticated => token != null;

  Future<void> checkAuth() async {
    try {
      token = await _storage.read(key: 'access_token');
      final prefs = await SharedPreferences.getInstance();
      userRole = prefs.getString('user_role');
    } catch (e) {
      debugPrint('Error checking auth: $e');
    } finally {
      isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> login(String username, String password) async {
    isLoading = true;
    error = null;
    userRole = null;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final base = prefs.getString('target_url') ?? ApiConstants.baseUrl;
      final dbName = prefs.getString('school_db_name');

      final api = ApiService(baseOverride: base);

      final Map<String, String> body = {
        'login': username,
        'password': password,
      };

      if (dbName != null) {
        body['db'] = dbName;
      }

      final res = await api.postForm(ApiConstants.loginApi, body);
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final status = data['status']?.toString();

      if (status == 'success') {
        final responseData = data['data'] as Map<String, dynamic>;
        token = responseData['access_token']?.toString();

        // Save access token in secure storage
        if (token != null) {
          await _storage.write(key: 'access_token', value: token);
          // Also save other details if needed, e.g., uid, user_role
          if (responseData['uid'] != null) {
            await prefs.setInt('uid', responseData['uid']);
          }
          if (responseData['user_role'] != null) {
            userRole = responseData['user_role'].toString();
            await prefs.setString('user_role', userRole!);
          }
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
