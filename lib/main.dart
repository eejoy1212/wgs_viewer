import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resizable_widget/resizable_widget.dart';
import 'package:wgs_viewer/controller/chart_ctrl.dart';
import 'package:wgs_viewer/controller/check_box_ctrl.dart';
import 'package:wgs_viewer/controller/dark_mode_ctrl.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/left_menu_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/controller/translator_ctrl.dart';
import 'package:wgs_viewer/mode.dart';
import 'package:wgs_viewer/view/widget/apply_btn_widget.dart';
import 'package:wgs_viewer/view/widget/file_list_data_widget.dart';
import 'package:wgs_viewer/model/checkbox_model.dart';
import 'package:wgs_viewer/view/widget/file_select_btn_widget.dart';
import 'package:wgs_viewer/view/widget/right_chart_widget.dart';
import 'package:wgs_viewer/view/widget/time_select_widget.dart';
import 'package:wgs_viewer/view/widget/left_chart_widget.dart';
import 'package:wgs_viewer/view/widget/window_btns_widget.dart';

void main() {
  Get.put(ctrl());
  Get.put(LeftMenuCtrl());
  Get.put(FilePickerCtrl());
  Get.put(DarkModeCtrl());
  Get.put(TimeSelectCtrl());
  Get.put(ChartCtrl());
  Get.put(CheckboxCtrl());
  Get.put(TranslatorCtrl());
  Get.put(RangeSliderCtrl());
  ChartCtrl.to.init();
  runApp(
    MyApp(),
  );
  doWhenWindowReady(() {
    final win = appWindow;
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
  // var allChecked = CheckBoxModel(title: 'All check', fileName: '', isChecked: true, range: );

  bool isDarkMode = false;

  toGetx() {
    ctrl.to.aaa.value = isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'viewer',
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: ctrl.to.aaa.value ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
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
                                        Get.find<ChartCtrl>()
                                            .visibleMode
                                            .value = 0;
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
                                        Get.find<ChartCtrl>()
                                            .visibleMode
                                            .value = 1;
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
                                        Get.find<ChartCtrl>()
                                            .visibleMode
                                            .value = 2;
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
                      Visibility(
                        visible: false,
                        child: ElevatedButton(
                          onPressed: () async {
                            TranslatorCtrl.to.input.value = '나는 26살이다.';
                            TranslatorCtrl.to.korToEn();
                          },
                          child: Text('Translator'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('add test'),
                      ),

                      // Obx(() {
                      // return Text('${TranslatorCtrl.to.korToEn()}');
                      // })

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
                              child: DayNightSwitcher(
                                  isDarkModeEnabled: ctrl.to.aaa.value
                                  //isDarkMode

                                  ,
                                  onStateChanged: onStateChanged),
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
                ),
              ),
            ),
            body:
                ResizableWidget(separatorColor: Colors.blueGrey, percentages: [
              Get.find<LeftMenuCtrl>().activateLeftMenu.value == true ? 0.2 : 0,
              Get.find<LeftMenuCtrl>().activateLeftMenu.value == true ? 0.8 : 1
            ], children: [
              //left menu

              Container(
                color: Colors.blueGrey[300],
                child: Column(
                  children: [
                    RangeSliders(),
                  ],
                ),
              ),
              ResizableWidget(
                //드래그 드롭 && 타임셀렉트 하는 부분 공간 줄이는 라인
                isHorizontalSeparator: true,
                separatorColor: Colors.blueGrey,
                children: [
                  Center(
                    child: Row(
                      children: [
                        Obx(
                          () => Visibility(
                            visible: Get.find<ChartCtrl>().visibleMode.value ==
                                        0 ||
                                    Get.find<ChartCtrl>().visibleMode.value == 2
                                ? true
                                : false,
                            child: Expanded(
                              flex: 1,
                              child: LeftChartWidget(),
                            ),
                          ),
                        ),
                        Obx(() => Visibility(
                              visible: Get.find<ChartCtrl>()
                                              .visibleMode
                                              .value ==
                                          1 ||
                                      Get.find<ChartCtrl>().visibleMode.value ==
                                          2
                                  ? true
                                  : false,
                              child: const Expanded(
                                flex: 1,
                                child: RightChartWidget(),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //파일 드래그 앤드 드롭, 파일 선택하는 곳
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.blueGrey.withOpacity(0.5),
                                    width: 2)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            DottedBorder(
                                                color: Colors.blueGrey,
                                                child: const Text('File List')),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            const FileSelectBtn(),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: const Color(
                                                        0xffD83737)),
                                                onPressed: () {
                                                  if (CheckboxCtrl
                                                          .to.isChecked.value ||
                                                      CheckboxCtrl
                                                              .to
                                                              .isAllChecked
                                                              .value ==
                                                          true) {
                                                    FilePickerCtrl
                                                        .to.selectedFileName
                                                        .removeAt(CheckboxCtrl
                                                            .to.selIdx.value);
                                                  } else {}
                                                },
                                                child: const Text(
                                                    'Selected File Delete')),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: const Color(
                                                        0xffD83737)),
                                                onPressed: () {
                                                  Get.defaultDialog(
                                                    title: 'All Files Delete',
                                                    content: Column(
                                                      children: const [
                                                        Divider(
                                                          indent: 6,
                                                          endIndent: 6,
                                                          color:
                                                              Colors.blueGrey,
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
                                                    confirmTextColor:
                                                        Colors.white,
                                                    textCancel: 'Yes',
                                                    cancelTextColor: Colors.red,
                                                    buttonColor:
                                                        Colors.blueGrey,
                                                    onCancel: () {
                                                      //차트 화면에서 지워주는거
                                                      ChartCtrl.to.forfields
                                                          .clear();
                                                      FilePickerCtrl
                                                          .to.selectedFileName
                                                          .clear();
                                                      FilePickerCtrl
                                                              .to
                                                              .selectedFileNum
                                                              .value =
                                                          FilePickerCtrl
                                                              .to
                                                              .selectedFileName
                                                              .value
                                                              .length;
                                                    },
                                                    onConfirm: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  );
                                                },
                                                child: const Text(
                                                    'All File Delete')),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      Obx(
                                        () => Text(
                                            'File num : ${FilePickerCtrl.to.selectedFileName.length}'),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                //파일 셀렉트하면 파일 나타나는 구간.
                                Expanded(
                                  flex: 5,
                                  child: FileListData(),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Obx(
                                          () => Text(
                                            FilePickerCtrl
                                                .to.fileMaxAlertMsg.string,
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        ApplyBtn(),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      //시간대 선택하는 곳
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.blueGrey.withOpacity(0.5),
                                  width: 2),
                            ),
                            child: const TimeSelectTxtForm(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                percentages: const [
                  0.8,
                  0.2,
                ],
              ),
            ])));
  }

  void onStateChanged(bool isDarkMode) {
    setState(() {
      this.isDarkMode = isDarkMode;
    });
    ctrl.to.aaa.value = isDarkMode;
  }

  // onItemClicked(CheckBoxModel ckbItem) {
  //   setState(() {
  //     ckbItem.value = !ckbItem.value;
  //   });
  // }

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
              FilePickerCtrl.to.selectedFileName.clear();

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
        Get.find<LeftMenuCtrl>().activateLeftMenu.value == false
            ? Get.find<LeftMenuCtrl>().activateLeftMenu.value = true
            : Get.find<LeftMenuCtrl>().activateLeftMenu.value = false;
      },
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }
}
