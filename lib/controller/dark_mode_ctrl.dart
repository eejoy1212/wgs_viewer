import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DarkModeCtrl extends GetxController {
  static DarkModeCtrl get to => Get.find();
  RxBool isDarkModeEnabled = false.obs;

  themeModeChanged(bool isDarkMode) {
    DarkModeCtrl.to.isDarkModeEnabled.value = isDarkMode;
  }

  sss() {
    DarkModeCtrl.to.isDarkModeEnabled.value ? ThemeMode.dark : ThemeMode.light;
  }
}
