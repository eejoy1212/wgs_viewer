import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TimeSelectCtrl extends GetxController {
  static TimeSelectCtrl get to => Get.find();
  RxInt firstTimeIdx = 0.obs;
  RxInt secondTimeIdx = 0.obs;
  RxList<double> tempList = [
    0.0,
    0.5,
    1.1,
    1.5,
    2.1,
    2.5,
    2.8,
    0.0,
    0.5,
    1.1,
    1.5,
    2.1,
    2.5,
    2.8,
    0.0,
    0.5,
    1.1,
    1.5,
    2.1,
    2.5,
    2.8,
    0.0,
    0.5,
    1.1,
    1.5,
    2.1,
    2.5,
    2.8,
    0.0,
    0.5,
    1.1,
    1.5,
    2.1,
    2.5,
    2.8,
    0.0,
    0.5,
    1.1,
    1.5,
    2.1,
    2.5,
    2.8,
    0.0,
    0.5,
    1.1,
    1.5,
    2.1,
    2.5,
    2.8,
    0.0,
    0.5,
    1.1,
    1.5,
    2.1,
    2.5,
    2.8,
    0.0,
    0.5,
    1.1,
    1.5,
    2.1,
    2.5,
    2.8,
    0.0,
    0.5,
    1.1,
    1.5,
    2.1,
    2.5,
    2.8,
    0.0,
    0.5,
    1.1,
    1.5,
    2.1,
    2.5,
    2.8,
  ].obs;
  //조절해야될거는 시간축(firstLine으로 일단넣어놓기)
  void firstIncrease() {
    firstTimeIdx++;
    update();
  }

  void firstDecrease() {
    firstTimeIdx--;
    debugPrint('시간 선택 $firstTimeIdx');
    update();
  }

  void secondIncrease() {
    secondTimeIdx++;
    debugPrint('시간 선택 2 $secondTimeIdx');
    update();
  }

  void secondDecrease() {
    secondTimeIdx--;

    debugPrint('시간 선택 2 $secondTimeIdx');
    update();
  }
}
