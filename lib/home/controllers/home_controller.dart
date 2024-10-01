import 'package:get/get.dart';

import '../model/api_model.dart';
import '../service/home_service.dart';

class HomeController extends GetxController {
  RxList<Data> data = <Data>[].obs;

  @override
  void onReady() {
    super.onReady();
    HomeService().fetchStories();
  }
}
