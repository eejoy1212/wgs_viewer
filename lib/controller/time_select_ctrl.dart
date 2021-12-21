import 'package:get/get.dart';

class TimeSelectCtrl extends GetxController {
  static TimeSelectCtrl get to => Get.find();
  double firstTimeVal = 0.0;
  double secondTimeVal = 0.0;
  void firstIncrease() {
    firstTimeVal++;
    update();
  }

  void firstDecrease() {
    firstTimeVal--;
    update();
  }

  void secondIncrease() {
    secondTimeVal++;
    update();
  }

  void secondDecrease() {
    secondTimeVal--;
    update();
  }
}
