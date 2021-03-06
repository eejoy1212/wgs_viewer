import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/view/widget/left_chart_widget.dart';
import 'package:wgs_viewer/view/widget/left_zoom_reset_btn.dart';

class LeftChartPg extends StatelessWidget {
  LeftChartPg({Key? key}) : super(key: key);
  bool start = false;

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
              child: LeftChartWidget(),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const LeftZoomResetBtn(),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                    onPressed: () {
                      DateTime current = DateTime.now();
                      ChartCtrl.to.fileName.value =
                          DateFormat('yyyyMMdd_HHmmss').format(current);
                      exportCSV("TimeBased");
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
          ]),
    );
  }

  void init() async {}

  void exportCSV(String name, [List<List<double>> data = const []]) async {
    String? _path = '';
    String csv = '.csv';
    _path = await FilePicker.platform.saveFile(
        type: FileType.any,
        fileName: 'filename$csv',
        // allowedExtensions: ['csv'],
        dialogTitle: 'File select');
    if (_path == null) {
      print('_path null : $_path');
    }
    if (_path!.substring(_path.length - 4, _path.length) != '.csv') {
      _path += '.csv';
    }
    final List<List<double>> fileData = [];

    String header = '';
    for (var i = 0; i < FilePickerCtrl.to.oesFD.length; i++) {
      for (var ii = 0; ii < RangeSliderCtrl.to.rsModel.length; ii++) {
        header +=
            ',${FilePickerCtrl.to.oesFD[i].fileName} ${RangeSliderCtrl.to.rsModel[ii].vStart.toStringAsFixed(3)}~${RangeSliderCtrl.to.rsModel[ii].vEnd.toStringAsFixed(3)}';
      }
    }

    for (var i = 0; i < TimeSelectCtrl.to.timeIdxList.length; i++) {
      fileData.add([]);

      fileData[i].add(TimeSelectCtrl.to.timeIdxList[i]);
      if (FilePickerCtrl.to.oesFD.isNotEmpty) {
        for (var ii = 0; ii < FilePickerCtrl.to.oesFD.length; ii++) {
          for (var iii = 0; iii < RangeSliderCtrl.to.rsModel.length; iii++) {
            if (FilePickerCtrl.to.oesFD[ii].isChecked.value != false) {
              if (i < ChartCtrl.to.forfields[ii][iii].length) {
                fileData[i].add(
                    ChartCtrl.to.forfields[ii][iii][i].yVal.roundToDouble());
              }
            }
          }
        }
      }
    }

    File file = File("$_path");
    List<dynamic> initData = [
      "FileFormat : 1",
      "Save Time : ",
      "Wavelength : "
    ];

    String all = initData.join('\n') +
        '\n' +
        "Time" +
        header +
        '\n' +
        fileData.map((line) => line.join(",")).join('\n');
    file.writeAsString(all);
  }
}
