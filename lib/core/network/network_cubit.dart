import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/network/network_info.dart';
import 'package:silent_space/core/network/network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  NetworkCubit({required this.networkInfo}) : super(NetworkInitial()) {
    _subscription = networkInfo.onConnectivityChanged.listen((results) {
      if (results.contains(ConnectivityResult.none)) {
        emit(NetworkDisconnected());
      } else {
        emit(NetworkConnected());
      }
    });
  }
  final NetworkInfo networkInfo;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
