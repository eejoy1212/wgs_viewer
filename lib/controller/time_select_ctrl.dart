import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TimeSelectCtrl extends GetxController {
  static TimeSelectCtrl get to => Get.find();
  RxInt firstTimeIdx = 0.obs;
  RxInt secondTimeIdx = 0.obs;
  RxBool timeSelected = false.obs;

  //조절해야될거는 시간축(firstLine으로 일단넣어놓기)
  void firstIncrease() {
    firstTimeIdx.value++;
    update();
  }

  void firstDecrease() {
    firstTimeIdx.value--;
    debugPrint('첫번째 시간 선택 인덱스 : ${firstTimeIdx.value}');
    update();
  }

  void secondIncrease() {
    secondTimeIdx.value++;
    debugPrint('두번째 시간 선택 인덱스 : ${secondTimeIdx.value}');
    update();
  }

  void secondDecrease() {
    secondTimeIdx.value--;

    debugPrint('두번째 시간 선택 인덱스 : ${secondTimeIdx.value}');
    update();
  }
}
