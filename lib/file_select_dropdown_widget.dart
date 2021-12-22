import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';

class FileSelectDropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> isEmptyList = ['파일을 불러주세요'];
    return Obx(() {
      return AwesomeDropDown(
        isPanDown: false,
        numOfListItemToShow: FilePickerCtrl.to.selectedFileName.length + 1,
        dropDownList: FilePickerCtrl.to.selectedFileName.isEmpty
            ? isEmptyList
            : FilePickerCtrl.to.selectedFileName,
      );
    });
  }
}
