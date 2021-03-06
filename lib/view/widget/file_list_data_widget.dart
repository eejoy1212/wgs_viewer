import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/model/oes_file_data_model.dart';

class CkbViewWidget extends StatelessWidget {
  const CkbViewWidget({Key? key, required this.oesFDModel, required this.idx})
      : super(key: key);
  // final CheckBoxModel ckb;
  final OESFileData oesFDModel;
  final int idx;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CheckboxListTile(
          selected: oesFDModel.isChecked.value,
          title: Text(
            '${idx + 1}  :   ${oesFDModel.fileName}',
            style: TextStyle(fontSize: 12),
          ),
          value: oesFDModel.isChecked.value,
          onChanged: (val) {
            if (val != null) {
              oesFDModel.isChecked.value = val;
            }
          }),
    );
  }
}

class FileListData extends StatelessWidget {
  final ScrollController scrollCtrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(children: [
        ListTile(
          title: Column(
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  SizedBox(width: 10),
                  Text('num'),
                  Spacer(),
                  Text('file name'),
                  Spacer(),
                  Text('check'),
                  SizedBox(width: 10),
                ],
              ),
              const Divider(),
            ],
          ),
          subtitle: SizedBox(
              height: 150,
              width: 500,
              child: ListView.separated(
                controller: scrollCtrl,
                shrinkWrap: true,
                itemCount: FilePickerCtrl.to.oesFD.length,
                itemBuilder: (BuildContext context, int index) {
                  return CkbViewWidget(
                      oesFDModel: FilePickerCtrl.to.oesFD[index], idx: index);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(height: 1),
              )),
        )
      ]),
    );
  }
}
