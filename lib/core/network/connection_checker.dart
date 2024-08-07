/* Package Imports */
import 'package:connectivity_plus/connectivity_plus.dart';

abstract interface class ConnectionChecker {
  Future<bool> get connected;
}

class ConnectionCheckerImpl implements ConnectionChecker {
  final Connectivity _checker;

  ConnectionCheckerImpl(
    this._checker,
  );

  @override
  Future<bool> get connected async {
    final result = await _checker.checkConnectivity();
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi)) {
      return true;
    } else {
      return false;
    }
  }
}
