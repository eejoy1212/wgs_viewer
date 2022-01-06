import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/file_select_dropdown_ctrl.dart';

class SecondFileSelectDropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> isEmptyList = ['파일을 불러주세요'];

    return Obx(() => DropdownSearch.multiSelection(
          mode: Mode.MENU,
          // showSelectedItems: true,
          showSearchBox: true,
          items: FilePickerCtrl.to.selectedFileName.isEmpty
              ? isEmptyList
              : FilePickerCtrl.to.selectedFileUrls,
          onChanged: FileSelectDropDownCtrl.to.SecondTimeFunc,
          onSaved: (newValue) {
            print('sadsada');
          },
        ));
  }
}
