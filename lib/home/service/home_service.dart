import 'dart:convert';

import 'package:emd_project/home/controllers/home_controller.dart';
import 'package:emd_project/home/model/api_model.dart';
import 'package:emd_project/utils/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../utils/utils.dart';
import '../view/widgets/response_dialog.dart';

class HomeService {
  final homeController = Get.find<HomeController>();

  Future<void> fetchStories() async {
    try {
      final response = await http.get(Uri.parse(AppConstants.baseUrl));

      var responseBodyDecoded =
          StoryResponseModel.fromJson(jsonDecode(response.body));
      prettyPrintJson(response.body);

      if (responseBodyDecoded.status == true) {
        homeController.data.value = responseBodyDecoded.data!;
      } else {
        Get.dialog(
            ResponseDialog(
                text: responseBodyDecoded.message!,
                onPressed: () {
                  Get.back();
                },
                isErrorDialog: true),
            barrierDismissible: false);
      }
    } catch (e) {
      logg.e(e);
      Get.dialog(
          ResponseDialog(
              text: 'Unable to connect to server, try again later',
              onPressed: () {
                Get.back();
              },
              isErrorDialog: true),
          barrierDismissible: false);
    }
  }
}
