import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/model/checkbox_model.dart';

class CheckBoxCtrl extends GetxController {
  static CheckBoxCtrl get to => Get.find();
  RxBool isChecked = false.obs;
  var fileList = RxList.empty();
  RxList checkboxList = [
//  if (FilePickerCtrl.to.selectedFileNum.value > 0)
//       {
//         CheckBoxModel(title: '${FilePickerCtrl.to.selectedFileName.value[0]}'),
//         CheckBoxModel(title: 'File 2'),
//         CheckBoxModel(title: 'File 3'),
//       }
//     else
//       {'file not exist.'}
    CheckBoxModel(title: 'file name'),
    CheckBoxModel(title: 'file name'),
    CheckBoxModel(title: 'file name'),
  ].obs;
  @override
  void onInit() async {
    super.onInit();
  }

  //
  updateFileList() {
    for (var i = 0; i < FilePickerCtrl.to.selectedFileName.length; i++) {
      fileList[i].add(FilePickerCtrl.to.selectedFileName);
      print('\nfile list : \n$fileList');
    }
  }

  onAllClicked(CheckBoxModel ckbItem) {
    final newValue = !ckbItem.value;
    // setState(() {
    //   ckbItem.value = newValue;
    //   checkboxList.forEach((element) {
    //     element.value = newValue;
    //   });
    // });
  }

  void onItemClicked(bool ischecked) {
    CheckBoxCtrl.to.isChecked.value = !ischecked;
    print('체크박스 상태 : ${CheckBoxCtrl.to.isChecked.value}');
    update();
  }
}
