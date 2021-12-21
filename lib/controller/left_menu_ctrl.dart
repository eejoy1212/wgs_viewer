import 'package:get/get.dart';

class LeftMenuCtrl extends GetxController {
  static LeftMenuCtrl get to => Get.find();
  RxBool activateLeftMenu = true.obs;
}
