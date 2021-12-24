import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/chart_ctrl.dart';
import 'package:wgs_viewer/controller/check_box_ctrl.dart';
import 'package:wgs_viewer/controller/dark_mode_ctrl.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/left_menu_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/controller/translator_ctrl.dart';
import 'package:wgs_viewer/main.dart';

void main() {
  Get.put(ctrl());
  Get.put(LeftMenuCtrl());
  Get.put(FilePickerCtrl());
  Get.put(DarkModeCtrl());
  Get.put(TimeSelectCtrl());
  Get.put(ChartCtrl());
  Get.put(CheckboxCtrl());
  Get.put(TranslatorCtrl());
  runApp(ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(1920, 100),
          child: SafeArea(
            child: Container(
              height: 60,
              color: Colors.blueGrey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        LeftMenuIcon(),
                        const SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          'assets/images/CI_nobg.png',
                          fit: BoxFit.fitHeight,
                          width: 100,
                        ),
                        const SizedBox(
                          width: 220,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Row(
                            children: [
                              const Text(
                                'Chart Show Mode :  ',
                                style: TextStyle(color: Colors.white),
                              ),
                              Tooltip(
                                message: 'Show only left chart',
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: const Color(0xFF15202B)),
                                  onPressed: () {
                                    Get.find<ChartCtrl>().visibleMode.value = 0;
                                  },
                                  child: const Text('left'),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Tooltip(
                                message: 'Show only right chart',
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: const Color(0xFF15202B)),
                                  onPressed: () {
                                    Get.find<ChartCtrl>().visibleMode.value = 1;
                                  },
                                  child: const Text('Right'),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Tooltip(
                                message: 'Show all chart',
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: const Color(0xFF15202B)),
                                  onPressed: () {
                                    Get.find<ChartCtrl>().visibleMode.value = 2;
                                  },
                                  child: const Text('All'),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Obx(() {
                    return Text('${TranslatorCtrl.to.korToEn()}');
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
