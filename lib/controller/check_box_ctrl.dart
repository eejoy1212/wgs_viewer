import 'package:get/get.dart';
import 'package:wgs_viewer/model/checkbox_model.dart';

class CheckboxCtrl extends GetxController {
  static CheckboxCtrl get to => Get.find();
  RxBool isChecked = false.obs;
  RxInt isAllChecked = 0.obs;
  RxBool isTap = false.obs;
  RxBool isSelected = false.obs;
  RxBool changed = false.obs;
  RxInt selIdx = 0.obs;
  ////Checkbox model 선언
  RxList<CheckBoxModel> ckb = RxList.empty();
}
