import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:server_core/server_core.dart';

class ConnectivityService extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  final Dio _pingDio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  bool _serverReachable = true;
  bool get serverReachable => _serverReachable;

  bool get canReachServer => _isOnline && _serverReachable;

  void initialize() {
    _subscription =
        _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
    _checkInitialState();
  }

  Future<void> _checkInitialState() async {
    final results = await _connectivity.checkConnectivity();
    _isOnline = results.any((r) => r != ConnectivityResult.none);
    if (_isOnline) {
      await _checkServerReachability();
    } else {
      _serverReachable = false;
    }
    notifyListeners();
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;
    _isOnline = results.any((r) => r != ConnectivityResult.none);
    if (_isOnline != wasOnline) {
      if (_isOnline) {
        _checkServerReachability();
      } else {
        _serverReachable = false;
        notifyListeners();
      }
    }
  }

  Future<void> _checkServerReachability() async {
    if (!GetIt.instance.isRegistered<MediaServerClient>()) {
      _serverReachable = false;
      notifyListeners();
      return;
    }
    final client = GetIt.instance<MediaServerClient>();
    try {
      await _pingDio.get('${client.baseUrl}/System/Ping');
      _serverReachable = true;
    } catch (_) {
      _serverReachable = false;
    }
    notifyListeners();
  }

  Future<void> recheckNow() async {
    final results = await _connectivity.checkConnectivity();
    _isOnline = results.any((r) => r != ConnectivityResult.none);
    if (_isOnline) {
      await _checkServerReachability();
    } else {
      _serverReachable = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
