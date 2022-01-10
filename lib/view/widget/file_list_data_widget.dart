import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/check_box_ctrl.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/model/checkbox_model.dart';

class CkbViewWidget extends StatelessWidget {
  const CkbViewWidget({Key? key, required this.ckb}) : super(key: key);
  final CheckBoxModel ckb;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(ckb.fileName),
      Obx(
        () => Checkbox(
            value: ckb.isChecked.value,
            onChanged: (val) {
              if (val != null) {
                ckb.isChecked.value = val;
                CheckboxCtrl.to.isChecked.value = ckb.isChecked.value;
                if (ckb.isChecked.isTrue) {
                  var oo = FilePickerCtrl.to.selectedFileName
                      .indexWhere((element) => element.contains(ckb.fileName));

                  debugPrint(
                      '${ckb.fileName}의 체크박스 idx $oo ${FilePickerCtrl.to.selectedFileName}');
                }
              }
            }),
      ),
    ]);
  }
}

class FileListData extends StatelessWidget {
  final ScrollController scrollCtrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Column(children: [
              SizedBox(
                child: ListTile(
                  // horizontalTitleGap: constraints.maxHeight,
                  title: Row(
                    children: [
                      SizedBox(
                        // height: 300,
                        height: constraints.maxHeight * 0.9,
                        width: constraints.maxWidth * 0.9,
                        child: Obx(() => Scrollbar(
                            isAlwaysShown: true,
                            child: ListView.builder(
                              itemCount: CheckboxCtrl.to.ckb.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CkbViewWidget(
                                    ckb: CheckboxCtrl.to.ckb[index]);
                              },
                            ))),
                      ),
                    ],
                  ),
                ),
              )
            ]));
  }
}
