import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkProvider with ChangeNotifier {
  bool isOnline = true;
  StreamSubscription<List<ConnectivityResult>>? _sub;

  NetworkProvider() {
    _init();
  }
  Future<void> _init() async {
    try {
      final initial = await Connectivity().checkConnectivity();
      final result = initial.isNotEmpty
          ? initial.first
          : ConnectivityResult.none;
      isOnline = result != ConnectivityResult.none;
      notifyListeners();
      final stream = Connectivity().onConnectivityChanged;
      _sub = stream.listen(
        (results) {
          final r = results.isNotEmpty
              ? results.first
              : ConnectivityResult.none;
          final online = r != ConnectivityResult.none;
          if (online != isOnline) {
            isOnline = online;
            notifyListeners();
          }
        },
        onError: (_) {
          isOnline = true;
          notifyListeners();
        },
      );
    } on MissingPluginException catch (_) {
      isOnline = true;
      notifyListeners();
    } on PlatformException catch (_) {
      isOnline = true;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
