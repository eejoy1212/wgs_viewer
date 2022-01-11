import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/model/oes_file_data_model.dart';

class CkbViewWidget extends StatelessWidget {
  const CkbViewWidget({Key? key, required this.oesFDModel}) : super(key: key);
  // final CheckBoxModel ckb;
  final OESFileData oesFDModel;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CheckboxListTile(
          selected: oesFDModel.isChecked.value,
          title: Text(oesFDModel.fileName),
          value: oesFDModel.isChecked.value,
          onChanged: (val) {
            if (val != null) {
              oesFDModel.isChecked.value = val;
              debugPrint(
                  '${oesFDModel.fileName} check : ${oesFDModel.isChecked.value}');
            }
          }),
    );
  }
}

class FileListData extends StatelessWidget {
  final ScrollController scrollCtrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(children: [
                ListTile(
                  title: Row(
                    children: [
                      SizedBox(
                        height: constraints.maxHeight * 0.9,
                        width: constraints.maxWidth * 0.9,
                        child: Obx(() => Scrollbar(
                            isAlwaysShown: true,
                            child: ListView.separated(
                              reverse: true,
                              itemCount: FilePickerCtrl.to.oesFD.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CkbViewWidget(
                                    oesFDModel: FilePickerCtrl.to.oesFD[index]);
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      Divider(height: 1),
                            ))),
                      ),
                    ],
                  ),
                )
              ]),
            ));
  }
}
