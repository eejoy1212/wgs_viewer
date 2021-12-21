import 'package:get/get.dart';

class DarkModeCtrl extends GetxController {
  static DarkModeCtrl get to => Get.find();
  RxBool isDarkModeEnabled = false.obs;
}
