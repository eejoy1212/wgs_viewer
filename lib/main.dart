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
import 'package:wgs_viewer/view/widget/body.dart';
import 'package:wgs_viewer/view/widget/file_list_data_widget.dart';
import 'package:wgs_viewer/view/widget/file_select_btn_widget.dart';
import 'package:wgs_viewer/view/page/right_chart_pg.dart';
import 'package:wgs_viewer/view/widget/time_select_widget.dart';
import 'package:wgs_viewer/view/page/left_chart_pg.dart';
import 'package:wgs_viewer/view/widget/window_btns_widget.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() {
  Get.put(ctrl());
  Get.put(MenuCtrl());
  Get.put(TimeSelectCtrl());
  Get.put(FilePickerCtrl(), permanent: true);
  Get.put(DarkModeCtrl());
  Get.put(ChartCtrl(), permanent: true);
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
  bool isOpen = false;
  final ScrollController drawerScrollCtrl = ScrollController();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        navigatorKey: navigatorKey,
        title: 'viewer',
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: ctrl.to.aaa.value ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            drawerEnableOpenDragGesture:
                Get.find<MenuCtrl>().activateLeftMenu.value,
            onDrawerChanged: (isOpened) {
              MenuCtrl.to.activateLeftMenu.value = isOpened;
              MenuCtrl.to.chartSize.value = 1;
            },
            appBar: AppBar(
              // toolbarHeight: 60,
              leadingWidth: 700,
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
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 16, left: 5),
                  //   child: ElevatedButton(
                  //       onPressed: () {
                  //         MenuCtrl.to.isBottomMenu.value = true;
                  //       },
                  //       child: Text('bottom menu')),
                  // )
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
                          TranslatorCtrl.to.korToEn();
                        },
                        child: const Text('Translator'),
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
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        DottedBorder(
                            color: Colors.blueGrey,
                            child: const Text('Range Select')),
                      ],
                    ),
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

                  //?????? ????????????

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

                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        const FileSelectBtn(),
                        const SizedBox(
                          width: 16,
                        ),
                        SizedBox(
                          height: 20,
                          width: 70,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: const Color(0xffD83737)),
                              onPressed: () {
                                FilePickerCtrl.to.oesFD.clear();
                                ChartCtrl.to.forfields.clear();
                                FilePickerCtrl.to.xWLs.clear();
                                FilePickerCtrl.to.oesFD = RxList.empty();
                                ChartCtrl.to.forfields = RxList.empty();
                                FilePickerCtrl.to.xWLs = RxList.empty();
                                FilePickerCtrl.to.xTimes.clear();
                                RangeSliderCtrl.to.isPbShow.value = false;
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(fontSize: 12),
                              )),
                        ),
                        const Spacer(),
                        ApplyBtn(),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  //??????????????? ?????? ???
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TimeSelectTxtForm(),
                  ),
                  const SizedBox(height: 50)
                ],
              ),
            ),
            body: Body()));

    //????????? ?????? && ??????????????? ?????? ?????? ?????? ????????? ??????
  }

  void onStateChanged(bool isDarkMode) {
    setState(() {
      this.isDarkMode = isDarkMode;
    });
    ctrl.to.aaa.value = isDarkMode;
  }

  void typeAlert() {
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
        content: const Text('?????? ????????? ????????????.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
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
      },
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }
}
