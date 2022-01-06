import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/check_box_ctrl.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/main.dart';
import 'package:wgs_viewer/model/checkbox_model.dart';

class FileSelectBtn extends StatefulWidget {
  const FileSelectBtn({Key? key}) : super(key: key);

  @override
  _FileSelectBtnState createState() => _FileSelectBtnState();
}

List temp = [];

class _FileSelectBtnState extends State<FileSelectBtn> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: const Color(0xffFF9110)),
      onPressed: () {
        // await FilePickerCtrl.to.selectedFileFunc();
        int nn = CheckboxCtrl.to.ckb.length;
        List<CheckBoxModel> ckbfirstList = [];
        ckbfirstList.add(
          CheckBoxModel(
            title: 'ds',
            fileName: '$nn번 파일 : ${FilePickerCtrl.to.selectedFileName[nn]} ',
            isChecked: false.obs,
            range: RangeModel(start: nn, end: nn + 2),
          ),
        );
        CheckboxCtrl.to.ckb.addAll(ckbfirstList);
      },
      child: const Text('File Select'),
    );
  }
}
