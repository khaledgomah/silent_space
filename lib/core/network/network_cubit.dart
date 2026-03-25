import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/network/network_info.dart';
import 'package:silent_space/core/network/network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final NetworkInfo networkInfo;
  late StreamSubscription<ConnectivityResult> _subscription;

  NetworkCubit({required this.networkInfo}) : super(NetworkInitial()) {
    _subscription = networkInfo.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        emit(NetworkDisconnected());
      } else {
        emit(NetworkConnected());
      }
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
