import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TimeSelectCtrl extends GetxController {
  static TimeSelectCtrl get to => Get.find();
  RxInt firstTimeIdx = 0.obs;
  RxInt secondTimeIdx = 0.obs;
  RxBool timeSelected = false.obs;
  RxList timeIdxList = RxList.empty();
  RxBool ableTimeSelect = false.obs;

  void init() {
    for (var i = 0; i < timeIdxList.length; i++) {
      timeIdxList.add([]);
    }
  }

  //조절해야될거는 시간축(firstLine으로 일단넣어놓기)
  void firstIncrease() {
    //첫번째 파일 시간 인덱스 기준
    if (timeIdxList.isEmpty) {
      debugPrint('인덱스 에러');
      firstTimeIdx.value = 0;
    } else if (firstTimeIdx.isNegative ||
        firstTimeIdx.value < timeIdxList.indexOf(timeIdxList.first) ||
        firstTimeIdx.value > timeIdxList.indexOf(timeIdxList.last)) {
      debugPrint('인덱스 에러 : 첫번째 파일 시간대의 인덱스를 벗어남');
      firstTimeIdx.value = 0;
    } else {
      firstTimeIdx.value++;
      update();
    }
  }

  void firstDecrease() {
    if (timeIdxList.isEmpty) {
      debugPrint('인덱스 에러');
      firstTimeIdx.value = 0;
    } else if (firstTimeIdx.isNegative ||
        firstTimeIdx.value < timeIdxList.indexOf(timeIdxList.first) ||
        firstTimeIdx.value > timeIdxList.indexOf(timeIdxList.last)) {
      debugPrint('인덱스 에러 : 첫번째 파일 시간대의 인덱스를 벗어남');
      firstTimeIdx.value = 0;
    } else {
      firstTimeIdx.value--;
      debugPrint('첫번째 시간 선택 인덱스 : ${firstTimeIdx.value}');
      update();
    }
  }

  void secondIncrease() {
    if (timeIdxList.isEmpty) {
      debugPrint('인덱스 에러');
      secondTimeIdx.value = 0;
    } else if (secondTimeIdx.isNegative ||
        secondTimeIdx.value < timeIdxList.indexOf(timeIdxList.first) ||
        secondTimeIdx.value > timeIdxList.indexOf(timeIdxList.last)) {
      debugPrint('인덱스 에러 : 인덱스를 벗어남 인덱스 0으로 돌아감');
      secondTimeIdx.value = 0;
    } else {
      secondTimeIdx.value++;
      debugPrint('두번째 시간 선택 인덱스 : ${secondTimeIdx.value}');
      update();
    }
  }

  void secondDecrease() {
    if (timeIdxList.isEmpty) {
      debugPrint('인덱스 에러');
      secondTimeIdx.value = 0;
    } else if (secondTimeIdx.isNegative ||
        secondTimeIdx.value < timeIdxList.indexOf(timeIdxList.first) ||
        secondTimeIdx.value > timeIdxList.indexOf(timeIdxList.last)) {
      debugPrint('인덱스 에러 : 인덱스를 벗어남, 인덱스 0으로 돌아감');
      secondTimeIdx.value = 0;
    } else {
      secondTimeIdx.value--;

      debugPrint('두번째 시간 선택 인덱스 : ${secondTimeIdx.value}');
      update();
    }
  }
}
