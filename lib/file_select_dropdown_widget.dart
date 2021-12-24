import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';

class FileSelectDropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> isEmptyList = ['파일을 불러주세요'];
    return Obx(() => DropdownSearch(
        mode: Mode.MENU,
        showSelectedItems: true,
        showSearchBox: true,
        items: FilePickerCtrl.to.selectedFileName.isEmpty
            ? isEmptyList
            : FilePickerCtrl.to.selectedFileName,
        onChanged: print,
        selectedItem: FilePickerCtrl.to.selectedFileName.isEmpty
            ? '파일을 불러주세요'
            : '파일을 선택해 주세요'));
  }
}
