import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:resizable_widget/resizable_widget.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:wgs_viewer/controller/chart_ctrl.dart';
import 'package:wgs_viewer/controller/check_box_ctrl.dart';
import 'package:wgs_viewer/controller/dark_mode_ctrl.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/left_menu_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/file_select_dropdown_widget.dart';
import 'package:wgs_viewer/view/widget/file_list_data_widget.dart';
import 'package:wgs_viewer/model/checkbox_model.dart';
import 'package:wgs_viewer/view/widget/file_select_btn_widget.dart';
import 'package:wgs_viewer/view/widget/right_chart_widget.dart';
import 'package:wgs_viewer/view/widget/time_select_widget.dart';
import 'package:wgs_viewer/view/widget/left_chart_widget.dart';
import 'package:wgs_viewer/view/widget/window_btns_widget.dart';

void main() {
  Get.put(LeftMenuCtrl());
  Get.put(FilePickerCtrl());
  Get.put(DarkModeCtrl());
  Get.put(TimeSelectCtrl());
  Get.put(ChartCtrl());
  Get.put(CheckboxCtrl());
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

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var allChecked = CheckBoxModel(title: 'All check');

  var checkboxList = [
    CheckBoxModel(title: '1'),
    CheckBoxModel(title: '2'),
    CheckBoxModel(title: '3'),
  ];
  bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'viewer',
        theme: ThemeData.light().copyWith(
          backgroundColor: Colors.blueGrey,
          appBarTheme: const AppBarTheme(
            color: Colors.blueGrey,
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          appBarTheme: const AppBarTheme(color: Colors.red),
          scaffoldBackgroundColor: const Color(0xFF15202B),
        ),
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: mainScreen());
  }

  onAllClicked(CheckBoxModel ckbItem) {
    final newValue = !ckbItem.value;
    setState(() {
      ckbItem.value = newValue;
      checkboxList.forEach((element) {
        element.value = newValue;
      });
    });
  }

  onItemClicked(CheckBoxModel ckbItem) {
    setState(() {
      ckbItem.value = !ckbItem.value;
    });
  }

  void themeModeChanged(bool isDarkMode) {
    setState(() {
      this.isDarkMode = isDarkMode;
    });
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
              FilePickerCtrl.to.selectedFileName.clear();
              print(
                  '\nAll File Delete Result : \n${FilePickerCtrl.to.selectedFileName}');
              print(
                  '\nAll File Delete Result length : \n${FilePickerCtrl.to.selectedFileName.length}');
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

class mainScreen extends StatelessWidget {
  const mainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Tooltip(
                        height: 30,
                        message: ''
                        // 'Dark mode is ' +
                        //     (isDarkMode ? 'enabled' : 'disabled') +
                        //     '.'
                        ,
                        child: DayNightSwitcher(
                            isDarkModeEnabled: true
                            // isDarkMode
                            ,
                            onStateChanged: themeModeChanged),
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
      body: ResizableWidget(separatorColor: Colors.blueGrey, percentages: [
        Get.find<LeftMenuCtrl>().activateLeftMenu.value == true ? 0.2 : 0,
        Get.find<LeftMenuCtrl>().activateLeftMenu.value == true ? 0.8 : 1
      ], children: [
        //left menu

        Container(
          color: Colors.blueGrey[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text('Wavelength 1'),
                  MaterialColorPicker(
                    circleSize: 150,
                    onColorChange: (Color color) {},
                    selectedColor: Colors.red,
                    colors: const [
                      Colors.red,
                      Colors.deepOrange,
                      Colors.yellow,
                      Colors.lightGreen
                    ],
                  ),
                  SfSlider(
                    min: 0,
                    max: 100,
                    value: 60,
                    interval: 20,
                    onChanged: (dynamic value) {},
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('Wavelength 2'),
                  MaterialColorPicker(
                    circleSize: 150,
                    onColorChange: (Color color) {},
                    selectedColor: Colors.red,
                    colors: const [
                      Colors.red,
                      Colors.deepOrange,
                      Colors.yellow,
                      Colors.lightGreen
                    ],
                  ),
                  SfSlider(
                    min: 0,
                    max: 100,
                    value: 60,
                    interval: 20,
                    onChanged: (dynamic value) {},
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('Wavelength 3'),
                  MaterialColorPicker(
                    circleSize: 150,
                    onColorChange: (Color color) {},
                    selectedColor: Colors.red,
                    colors: const [
                      Colors.red,
                      Colors.deepOrange,
                      Colors.yellow,
                      Colors.lightGreen
                    ],
                  ),
                  SfSlider(
                    min: 0,
                    max: 100,
                    value: 60,
                    interval: 20,
                    onChanged: (dynamic value) {
                      // setState(() {
                      //   60 = value;
                      // });
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('Wavelength 4'),
                  MaterialColorPicker(
                    circleSize: 150,
                    onColorChange: (Color color) {},
                    selectedColor: Colors.red,
                    colors: const [
                      Colors.red,
                      Colors.deepOrange,
                      Colors.yellow,
                      Colors.lightGreen
                    ],
                  ),
                  SfSlider(
                    min: 0,
                    max: 100,
                    value: 60,
                    interval: 20,
                    onChanged: (dynamic value) {
                      // setState(() {
                      //   60 = value;
                      // });
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('Wavelength 5'),
                  MaterialColorPicker(
                    circleSize: 150,
                    onColorChange: (Color color) {},
                    selectedColor: Colors.red,
                    colors: const [
                      Colors.red,
                      Colors.deepOrange,
                      Colors.yellow,
                      Colors.lightGreen
                    ],
                  ),
                  SfSlider(
                    min: 0,
                    max: 100,
                    value: 60,
                    interval: 20,
                    onChanged: (dynamic value) {
                      // setState(() {
                      //   60 = value;
                      // });
                    },
                  ),
                ],
              ),
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
                      visible: Get.find<ChartCtrl>().visibleMode.value == 0 ||
                              Get.find<ChartCtrl>().visibleMode.value == 2
                          ? true
                          : false,
                      child: const Expanded(
                        flex: 1,
                        child:
                            // InkWell(
                            //   onTap: () {
                            //     //left Chat 클릭 하면, left Chart만 보이게 하기.
                            //     Get.find<ChartCtrl>().visibleMode.value = 0;
                            //   },
                            //   onDoubleTap: () {
                            //     //left Chat 더블 클릭 하면, 양쪽 차트 다 보이게 하기.
                            //     Get.find<ChartCtrl>().visibleMode.value = 2;
                            //   },
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(10),
                            //     child: Container(
                            //       color: Colors.green,
                            //       child: Column(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.spaceBetween,
                            //           children: [
                            //             const Padding(
                            //               padding: EdgeInsets.only(top: 300.0),
                            //               child: Text(
                            //                 'left chart',
                            //                 style: TextStyle(fontSize: 30),
                            //               ),
                            //             ),
                            //             Row(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.end,
                            //               children: [
                            //                 ElevatedButton.icon(
                            //                   style: ElevatedButton.styleFrom(
                            //                       primary: Colors.blueAccent),
                            //                   onPressed: () {},
                            //                   icon: const Icon(
                            //                     Icons.file_copy_outlined,
                            //                     size: 20,
                            //                   ),
                            //                   label: const Text('Export'),
                            //                 ),
                            //               ],
                            //             ),
                            //           ]),
                            //     ),
                            //   ),
                            // ),

                            LeftChartWidget(),
                      ),
                    ),
                  ),
                  Obx(() => Visibility(
                        visible: Get.find<ChartCtrl>().visibleMode.value == 1 ||
                                Get.find<ChartCtrl>().visibleMode.value == 2
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
                                              primary: const Color(0xffD83737)),
                                          onPressed: () {
                                            if (CheckboxCtrl
                                                    .to.isChecked.value ||
                                                CheckboxCtrl.to.isAllChecked
                                                        .value ==
                                                    true) {
                                              FilePickerCtrl.to.selectedFileName
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
                                              primary: const Color(0xffD83737)),
                                          onPressed: () {
                                            Get.defaultDialog(
                                              title: 'All Files Delete',
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
                                                FilePickerCtrl
                                                    .to.selectedFileName
                                                    .clear();
                                                FilePickerCtrl.to
                                                        .selectedFileNum.value =
                                                    FilePickerCtrl
                                                        .to
                                                        .selectedFileName
                                                        .value
                                                        .length;
                                                print(
                                                    '\nAll File Delete Result : \n${FilePickerCtrl.to.selectedFileName}');
                                                print(
                                                    '\nAll File Delete Result length : \n${FilePickerCtrl.to.selectedFileName.length}');
                                              },
                                              onConfirm: () {
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          },
                                          child: const Text('All File Delete')),
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
                          Expanded(flex: 3, child: FileListData()),
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
                                                  .to.selectedFileName.length >
                                              100
                                          ? 'File maximum is 100'
                                          : '',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: const Color(0xff5AEDCA)),
                                      onPressed: () async {
                                        // print('데이터를 차트로 보내기');
                                        // await CheckBoxCtrl.to.updateFileList();
                                      },
                                      child: const Text(
                                        'Apply',
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.bold),
                                      ))
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
                            color: Colors.blueGrey.withOpacity(0.5), width: 2),
                      ),
                      child: const TimeSelectTxtForm(),
                    ),
                  ),
                )
              ],
            ),
          ],
          percentages: const [
            0.8,
            0.2,
          ],
        ),
      ]),
    );
  }

  themeModeChanged(bool isDarkModeEnabled) {}
}

class LeftMenuIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // ignore: avoid_print
        print('햄버거 메뉴 열기');
        Get.find<LeftMenuCtrl>().activateLeftMenu.value == false
            ? Get.find<LeftMenuCtrl>().activateLeftMenu.value = true
            : Get.find<LeftMenuCtrl>().activateLeftMenu.value = false;
        // ignore: avoid_print
        print(
            'activateLeftMenu : ${Get.find<LeftMenuCtrl>().activateLeftMenu.value}');
      },
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }
}
