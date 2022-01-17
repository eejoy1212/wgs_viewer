import 'dart:math';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:resizable_widget/resizable_widget.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/check_box_ctrl.dart';
import 'package:wgs_viewer/controller/dark_mode_ctrl.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/left_menu_ctrl.dart';
import 'package:wgs_viewer/controller/file_select_dropdown_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';
import 'package:wgs_viewer/controller/right_chart_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/controller/translator_ctrl.dart';
import 'package:wgs_viewer/mode.dart';
import 'package:wgs_viewer/view/widget/apply_btn_widget.dart';
import 'package:wgs_viewer/view/widget/file_list_data_widget.dart';
import 'package:wgs_viewer/view/widget/file_select_btn_widget.dart';
import 'package:wgs_viewer/view/page/right_chart_pg.dart';
import 'package:wgs_viewer/view/widget/time_select_widget.dart';
import 'package:wgs_viewer/view/page/left_chart_pg.dart';
import 'package:wgs_viewer/view/widget/window_btns_widget.dart';

void main() {
  Get.put(ctrl());
  Get.put(LeftMenuCtrl());
  Get.put(TimeSelectCtrl());
  Get.put(FilePickerCtrl(), permanent: true);
  Get.put(DarkModeCtrl());
  Get.put(ChartCtrl());
  Get.put(RightChartCtrl());
  Get.put(CheckboxCtrl());
  Get.put(TranslatorCtrl());
  Get.put(RangeSliderCtrl());
  Get.put(FileSelectDropDownCtrl());
  RangeSliderCtrl.to.init();
  ChartCtrl.to.init();
  RightChartCtrl.to.init();
  TimeSelectCtrl.to.init();
  runApp(
    MyApp(),
  );
  doWhenWindowReady(() {
    final win = appWindow;
    // const initialSize = Size(1920, 1080);
    const initialSize = Size(1920, 1080);
    win.minSize = initialSize;
    win.maxSize = initialSize;
    win.size = initialSize;

    win.alignment = Alignment.center;
    win.title = "viewer";

    win.show();
  });
}

class ctrl extends GetxController {
  static ctrl get to => Get.find();
  RxBool aaa = false.obs;
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  final ScrollController drawerScrollCtrl = ScrollController();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'viewer',
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: ctrl.to.aaa.value ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          drawerEnableOpenDragGesture:
              Get.find<LeftMenuCtrl>().activateLeftMenu.value
          //  true,
          ,
          onDrawerChanged: (isOpened) {
            LeftMenuCtrl.to.activateLeftMenu.value = isOpened;
            LeftMenuCtrl.to.chartSize.value = 1;
            debugPrint('isOpened? : $isOpened');
          },
          appBar: AppBar(
            // toolbarHeight: 60,
            leadingWidth: 600,
            leading: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: LeftMenuIcon(),
                ),

                // Drawer(),
                const SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Image.asset(
                    'assets/images/CI_nobg.png',
                    fit: BoxFit.fitHeight,
                    width: 100,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
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

                // const SizedBox(
                //   width: 220,
                // ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [],
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: ElevatedButton(
                      onPressed: () async {
                        // TranslatorCtrl.to.input.value = '나는 26살이다.';
                        TranslatorCtrl.to.korToEn();
                      },
                      child: Text('Translator'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        Tooltip(
                          height: 30,
                          message: ''
                                  'Dark mode is ' +
                              (isDarkMode ? 'enabled' : 'disabled') +
                              '.',
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: FlutterSwitch(
                                width: 60,
                                height: 20,
                                toggleSize: 10,
                                activeColor: Color(0xFF15202B),
                                activeToggleColor: Color(0xffd7b787),
                                inactiveColor: Colors.blue,
                                inactiveToggleColor: Color(0xfffcce97),
                                value: isDarkMode,
                                onToggle: onStateChanged),
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        WindowBtns(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              controller: drawerScrollCtrl,
              padding: EdgeInsets.zero,
              children: [
                Row(
                  children: [
                    DottedBorder(
                        color: Colors.blueGrey,
                        child: const Text('Range Select')),
                  ],
                ),
                Column(
                  children: RangeSliderCtrl.to.rsList(),
                ),

                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      DottedBorder(
                          color: Colors.blueGrey,
                          child: const Text('File List')),
                      Spacer(),
                      Obx(
                        () => Text(
                            'File num : ${FilePickerCtrl.to.oesFD.length}'),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const FileSelectBtn(),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 80,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: const Color(0xffD83737)),
                            onPressed: () {
                              FilePickerCtrl.to.oesFD
                                  .removeWhere((e) => e.isChecked.isTrue);
                            },
                            child: const Text(
                              'Selected Delete',
                              style: TextStyle(fontSize: 12),
                            )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: const Color(0xffD83737)),
                          onPressed: () {
                            Get.defaultDialog(
                              title: 'All Delete',
                              content: Column(
                                children: const [
                                  Divider(
                                    indent: 6,
                                    endIndent: 6,
                                    color: Colors.blueGrey,
                                  ),
                                  Text(
                                    'Do you want to delete all?',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              textConfirm: 'No',
                              confirmTextColor: Colors.white,
                              textCancel: 'Yes',
                              cancelTextColor: Colors.red,
                              buttonColor: Colors.blueGrey,
                              onCancel: () {
                                FilePickerCtrl.to.oesFD.clear();
                                ChartCtrl.to.forfields.clear();
                                // FilePickerCtrl.to.oesFD =
                                //     RxList.empty(
                                //         growable: true);
                              },
                              onConfirm: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                          child: const Text(
                            'All Delete',
                            style: TextStyle(fontSize: 12),
                          )),
                    ],
                  ),
                )

                //파일 리스트뷰
                ,
                Obx(() {
                  return FilePickerCtrl.to.oesFD.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey,
                            child: const Center(
                              child: Text('No Files'),
                            ),
                          ),
                        )
                      : FileListData();
                }),
                Obx(
                  () => Text(
                    FilePickerCtrl.to.fileMaxAlertMsg.string,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      ApplyBtn(),
                    ],
                  ),
                ),
                //타임셀렉트 하는 곳
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.blueGrey.withOpacity(0.5), width: 2),
                    ),
                    child: const TimeSelectTxtForm(),
                  ),
                ),
              ],
            ),
          ),
          body:

              //드래그 드롭 && 타임셀렉트 하는 부분 공간 줄이는 라인

              Center(
            child: Row(
              children: [
                Obx(() => LeftMenuCtrl.to.chartSize.value == 0
                    ? SizedBox()
                    : Visibility(
                        visible: LeftMenuCtrl.to.activateLeftMenu.value,
                        child: SizedBox(
                          width: 300,
                        ),
                      )),
                Obx(
                  () => Visibility(
                    visible: Get.find<ChartCtrl>().visibleMode.value == 0 ||
                            Get.find<ChartCtrl>().visibleMode.value == 2
                        ? true
                        : false,
                    child: Expanded(
                      flex: 1,
                      child: LeftChartPg(),
                    ),
                  ),
                ),
                Obx(() => Visibility(
                      visible: Get.find<ChartCtrl>().visibleMode.value == 1 ||
                              Get.find<ChartCtrl>().visibleMode.value == 2
                          ? true
                          : false,
                      child: Expanded(
                        flex: 1,
                        child: RightChartPg(),
                      ),
                    ))
              ],
            ),
          ),
        ));
  }

  void onStateChanged(bool isDarkMode) {
    setState(() {
      this.isDarkMode = isDarkMode;
    });
    ctrl.to.aaa.value = isDarkMode;
  }

  void realDeleteAlert() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Column(
          children: const [
            Text('All Files Delete'),
            Divider(
              color: Colors.blueGrey,
              indent: 6,
              endIndent: 6,
            ),
          ],
        ),
        content: const Text('Do you want to delete all?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              FilePickerCtrl.to.oesFD.clear();

              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }
}

class LeftMenuIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Scaffold.of(context).openDrawer();
        debugPrint(
            'left menu : ${Get.find<LeftMenuCtrl>().activateLeftMenu.value}');
      },
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }
}
