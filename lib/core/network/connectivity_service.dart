import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityService {
  Stream<bool> get connectionStream;
  Future<bool> checkConnection();
}

class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStreamController =
      StreamController<bool>.broadcast();

  ConnectivityServiceImpl() {
    // Lắng nghe sự thay đổi kết nối
    _connectivity.onConnectivityChanged.listen((results) {
      // Kiểm tra nếu có ít nhất một kết nối không phải là 'none'
      final isConnected = _hasConnection(results);
      _connectionStreamController.add(isConnected);
    });

    // Kiểm tra kết nối ban đầu
    checkConnection().then((isConnected) {
      _connectionStreamController.add(isConnected);
    });
  }

  @override
  Stream<bool> get connectionStream => _connectionStreamController.stream;

  @override
  Future<bool> checkConnection() async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnection(results);
  }

  // Kiểm tra xem có kết nối nào không phải là 'none' không
  bool _hasConnection(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any((result) => result != ConnectivityResult.none);
  }

  void dispose() {
    _connectionStreamController.close();
  }
}
