import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/file_select_dropdown_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';
import 'package:wgs_viewer/controller/right_chart_ctrl.dart';
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
            onChanged: (val) async {
              FileSelectDropDownCtrl.to.selected[idx] = val!;
              //FileSelectDropDownCtrl.to.fff(f: val!);
              // FileSelectDropDownCtrl.to
              //     .firstTimeFunc(firstList: FilePickerCtrl.to.oesFD);

              // FileSelectDropDownCtrl.to.applySignal.value = true;

              if (val != null) {
                debugPrint('파일 들어온게 null아니니까 apply버튼 활성화상태');
                if (idx == 0 || RangeSliderCtrl.to.pbSignal.isTrue) {
                  FileSelectDropDownCtrl.to.applySignal0.value = true;
                  //오른쪽 차트 파일 선택하자마자 업데이트 되게하기
                  TimeSelectCtrl.to.timeSelected.value = true;
                  await RightChartCtrl.to.updateRightData(idx);
                }
                if (idx == 1 || RangeSliderCtrl.to.pbSignal.isTrue) {
                  FileSelectDropDownCtrl.to.applySignal1.value = true;
                  //오른쪽 차트 파일 선택하자마자 업데이트 되게하기
                  TimeSelectCtrl.to.timeSelected.value = true;
                  await RightChartCtrl.to.updateRightData(idx);
                }
              } else {
                debugPrint('파일 들어온게 null 이니까 apply버튼 비활성화상태');
              }
            },
          ));
    });
  }
}
