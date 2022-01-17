import 'dart:io';
import 'dart:convert' show utf8;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:string_converter/converter.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/file_select_dropdown_ctrl.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/right_chart_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/view/widget/right_chart_widget.dart';

class RightChartPg extends StatelessWidget {
  RightChartPg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 10,
            child: RightChartWidget(),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                  onPressed: () {
                    DateTime current = DateTime.now();
                    ChartCtrl.to.fileName.value =
                        DateFormat('yyyyMMdd_HHmmss').format(current);
                    rightExportCSV("Wavelength");
                  },
                  icon: const Icon(
                    Icons.file_copy_outlined,
                    size: 20,
                  ),
                  label: const Text('Export'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void rightExportCSV(String name, [List<dynamic> data = const []]) async {
  StringConverter converter = StringConverter();
  String? _path = '';
  _path = await FilePicker.platform.saveFile(
      type: FileType.custom,
      fileName: '제목 없음.csv',
      allowedExtensions: ['csv'],
      dialogTitle: 'File select');
  if (_path != '') {
    print('_path $_path');
  }

  List header = [];

  String firstData = RightChartCtrl.to.rightSeriesData[0]
      .map((e) => e.yVal)
      .join(',')
      .toString();
  String secondData = RightChartCtrl.to.rightSeriesData[1]
      .map((e) => e.yVal)
      .join(',')
      .toString();
  File file = File('$_path');
  List<dynamic> initData = ["FileFormat : 1", "Save Time : ", "Wavelength : "];

  String all = initData.join('\n') +
      '\n' +
      "FileName/Time," +
      FilePickerCtrl.to.xWLs.join(',') +
      '\n' +
      converter
          .toUTF32(FileSelectDropDownCtrl.to.selected[0].fileName)
          .toUTF8() +
      ' / ' +
      TimeSelectCtrl.to.timeIdxList[TimeSelectCtrl.to.firstTimeIdx.value]
          .toString() +
      ',' +
      firstData +
      '\n' +
      converter
          .toUTF32(FileSelectDropDownCtrl.to.selected[1].fileName)
          .toUTF8() +
      ' / ' +
      TimeSelectCtrl.to.timeIdxList[TimeSelectCtrl.to.secondTimeIdx.value]
          .toString() +
      ',' +
      secondData +
      '\n';
  file.writeAsString(converter.toUTF32(all).toUTF8(), encoding: utf8);
  var iii = utf8.encode(FileSelectDropDownCtrl.to.selected[1].fileName);

  var test = 'wonhee';
  debugPrint('utf_8 : ${converter.toUTF32(all).toUTF8()}');
}
