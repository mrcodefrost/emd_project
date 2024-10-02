import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../home/controllers/home_controller.dart';
import 'internet_controller.dart';

class DependencyInjection {
  static void init() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    Get.put<InternetController>(InternetController(), permanent: true);
    Get.put(HomeController());
  }
}
