import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myschooly/src/services/apiservice.dart';
import 'package:myschooly/src/services/apierrors.dart';
import 'package:myschooly/src/services/apiconstants.dart';
import 'package:myschooly/src/models/verify_token_model.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? profile;
  String? token;
  String? userRole;
  UserData? userData;
  bool isInitialized = false;
  bool onboardingSeen = false;
  bool minSplashElapsed = false;

  bool get isAuthenticated => token != null;

  Future<void> checkAuth() async {
    try {
      token = await _storage.read(key: 'access_token');
      final prefs = await SharedPreferences.getInstance();
      userRole = prefs.getString('user_role');
      onboardingSeen = prefs.getBool('onboarding_seen') ?? false;

      Future.delayed(const Duration(milliseconds: 1200), () {
        minSplashElapsed = true;
        notifyListeners();
      });

      if (token != null) {
        await fetchUserDetails();
      }
    } catch (e) {
      debugPrint('Error checking auth: $e');
    } finally {
      isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> fetchUserDetails({bool force = false}) async {
    if (token == null) return;
    if (isLoading && !force) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final base = prefs.getString('target_url') ?? ApiConstants.baseUrl;
      final dbName = prefs.getString('school_db_name');

      final api = ApiService(baseOverride: base);

      final Map<String, String> body = {'access_token': token!};
      if (dbName != null) {
        body['db'] = dbName;
      }

      final res = await api.postForm(ApiConstants.verifyTokenApi, body);
      final jsonMap = jsonDecode(res.body) as Map<String, dynamic>;
      final response = VerifyTokenResponse.fromJson(jsonMap);

      if (response.status == 'success') {
        final newData = response.data;
        if (newData != null) {
          bool shouldNotify = false;

          // Check if data actually changed
          if (userData != newData) {
            userData = newData;
            shouldNotify = true;
          }

          // Check if role specifically changed (and needs persisting)
          if (newData.userRole != null && userRole != newData.userRole) {
            userRole = newData.userRole;
            await prefs.setString('user_role', userRole!);
            shouldNotify = true;
          }

          if (shouldNotify) {
            notifyListeners();
          }
        }
      } else if (response.status == 'error' &&
          (response.message?.contains('Token expired') ?? false)) {
        await logout();
      }
    } catch (e) {
      debugPrint('Error fetching user details: $e');
      if (e.toString().contains('Token expired') ||
          e.toString().contains('invalid')) {
        await logout();
      }
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final base = prefs.getString('target_url') ?? ApiConstants.baseUrl;
      final dbName = prefs.getString('school_db_name');
      final currentToken = token ?? await _storage.read(key: 'access_token');

      if (currentToken != null) {
        final api = ApiService(baseOverride: base);
        final Map<String, String> body = {
          'access_token': currentToken,
        };
        if (dbName != null) {
          body['db'] = dbName;
        }

        await api.postForm(ApiConstants.logoutApi, body);
      }
    } catch (e) {
      debugPrint('Logout API error: $e');
    } finally {
      token = null;
      userRole = null;
      userData = null;
      error = null;

      await _storage.delete(key: 'access_token');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_role');
      await prefs.remove('uid');
      // Note: We keep 'target_url' and 'school_db_name' so user doesn't need to re-enter school code

      notifyListeners();
    }
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    onboardingSeen = true;
    notifyListeners();
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
          // Fetch full details immediately
          await fetchUserDetails(force: true);
        }
      } else {
        error = data['message']?.toString() ?? 'Login failed';
      }
    } catch (e) {
      error = _extractErrorMessage(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _extractErrorMessage(dynamic e) {
    String? content;

    // 1. Get the content that might contain JSON
    if (e is AppException) {
      content = e.message;
    }

    // If content is null (or e is not AppException), use toString() as fallback for search
    content ??= e.toString();

    try {
      // Try finding JSON within the content
      final startIndex = content.indexOf('{');
      final endIndex = content.lastIndexOf('}');
      if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
        final jsonStr = content.substring(startIndex, endIndex + 1);
        final data = jsonDecode(jsonStr);
        if (data is Map && data.containsKey('message')) {
          return data['message'].toString();
        }
      }
    } catch (_) {}

    // Fallback
    if (e is AppException) {
      return e.message ?? e.toString();
    }
    return e.toString();
  }
}
