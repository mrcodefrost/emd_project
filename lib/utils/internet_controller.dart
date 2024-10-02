import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InternetController extends GetxController {
  final _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();

    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    if (connectivityResult.contains(ConnectivityResult.none)) {
      Get.rawSnackbar(
          messageText: const Text(
            'Connect to the internet, then pull to refresh',
            style: TextStyle(color: Colors.white),
          ),
          isDismissible: false,
          duration: Duration(days: 1),
          snackStyle: SnackStyle.GROUNDED,
          icon: const Icon(Icons.wifi_off, color: Colors.white),
          padding: EdgeInsets.only(left: 10, top: 20, bottom: 20));
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}
