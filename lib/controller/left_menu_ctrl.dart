import 'package:get/get.dart';

class LeftMenuCtrl extends GetxController {
  static LeftMenuCtrl get to => Get.find();
  RxBool activateLeftMenu = true.obs;
  /*0이면 처음상태(컨테이너 없음) */
  RxInt chartSize = 0.obs;
}
