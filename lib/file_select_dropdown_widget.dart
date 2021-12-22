import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';

class FileSelectDropDown extends StatefulWidget {
  @override
  _FileSelectDropDownState createState() => _FileSelectDropDownState();
}

class _FileSelectDropDownState extends State<FileSelectDropDown> {
  @override
  Widget build(BuildContext context) {
    List<String> asa = ['파일을 불러주세요'];
    return AwesomeDropDown(
      //dropDownList: asa,
      dropDownList: FilePickerCtrl.to.selectedFileName.isEmpty
          ? asa
          : FilePickerCtrl.to.selectedFileName,
    );
  }
}
