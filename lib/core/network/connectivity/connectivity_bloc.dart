import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../connectivity_service.dart';
import 'connectivity_event.dart';
import 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService _connectivityService;
  late StreamSubscription _connectivitySubscription;

  ConnectivityBloc(this._connectivityService) : super(ConnectivityInitial()) {
    on<CheckConnectivity>(_onCheckConnectivity);
    on<ConnectivityChanged>(_onConnectivityChanged);

    // Lắng nghe sự thay đổi kết nối
    _connectivitySubscription = _connectivityService.connectionStream.listen((isConnected) {
      add(ConnectivityChanged(isConnected));
    });

    // Kiểm tra kết nối ban đầu
    add(CheckConnectivity());
  }

  Future<void> _onCheckConnectivity(CheckConnectivity event, Emitter<ConnectivityState> emit) async {
    final isConnected = await _connectivityService.checkConnection();
    if (isConnected) {
      emit(ConnectivityConnected());
    } else {
      emit(ConnectivityDisconnected());
    }
  }

  void _onConnectivityChanged(ConnectivityChanged event, Emitter<ConnectivityState> emit) {
    if (event.isConnected) {
      emit(ConnectivityConnected());
    } else {
      emit(ConnectivityDisconnected());
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
} 