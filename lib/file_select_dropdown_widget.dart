import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/file_select_dropdown_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/model/oes_file_data_model.dart';

class FileSelectDropDown extends StatelessWidget {
  const FileSelectDropDown({Key? key, required this.idx}) : super(key: key);
  final int idx;

  List<OESFileData> aaa() {
    List<OESFileData> rt = [];
    for (var i = 0; i < FilePickerCtrl.to.oesFD.length; i++) {
      if (FilePickerCtrl.to.oesFD[i].isChecked.value) {
        rt.add(FilePickerCtrl.to.oesFD[i]);
      }
    }

    return rt;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return IgnorePointer(
          ignoring: TimeSelectCtrl.to.ableTimeSelect.value == false,
          child: DropdownSearch<OESFileData>(
            mode: Mode.MENU,
            showSearchBox: true,
            items: aaa(),
            onChanged: (val) {
              FileSelectDropDownCtrl.to.selected[idx] = val!;
              //FileSelectDropDownCtrl.to.fff(f: val!);
              // FileSelectDropDownCtrl.to
              //     .firstTimeFunc(firstList: FilePickerCtrl.to.oesFD);
            },
          ));
    });
  }
}
