import 'package:flutter/material.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';

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
      onPressed: () async {
        FilePickerCtrl.to.selectedFileFunc();
      },
      child: const Text('File Select'),
    );
  }
}
