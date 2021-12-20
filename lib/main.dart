import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cross_file/cross_file.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_menu/flutter_menu.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:resizable_widget/resizable_widget.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:wgs_viewer/checkbox_list_test.dart';
import 'package:wgs_viewer/model/all_checkbox_model.dart';
import 'package:wgs_viewer/time_select_test.dart';
import 'package:wgs_viewer/window_btns.dart';
import 'drag_drop_widget.dart';
import 'package:wgs_viewer/style/color.dart';

import 'chart_two_pg.dart';

void main() {
  Get.put(LeftMenuCtrl());
  Get.put(DarkModeCtrl());
  Get.put(TimeSelectCtrl());
  runApp(MyApp());
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
  bool isDarkMode = false;
  var allChecked = CheckBoxModel(title: 'All check');

  var checkboxList = [
    CheckBoxModel(title: '1'),
    CheckBoxModel(title: '2'),
    CheckBoxModel(title: '3'),
  ];
  @override
  Widget build(BuildContext context) {
    double _value = 60;
    return GetMaterialApp(
      title: 'viewer',
      theme: ThemeData.light().copyWith(
        backgroundColor: Colors.blueGrey,
        appBarTheme: AppBarTheme(
          color: Colors.blueGrey,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(color: Colors.red),
        scaffoldBackgroundColor: const Color(0xFF15202B),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(1920, 100),
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
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            print('햄버거 메뉴 열기');
                            Get.find<LeftMenuCtrl>().activateLeftMenu.value ==
                                    false
                                ? Get.find<LeftMenuCtrl>()
                                    .activateLeftMenu
                                    .value = true
                                : Get.find<LeftMenuCtrl>()
                                    .activateLeftMenu
                                    .value = false;
                            print(
                                'activateLeftMenu : ${Get.find<LeftMenuCtrl>().activateLeftMenu.value}');
                          },
                          child: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          'assets/images/CI_nobg.png',
                          fit: BoxFit.fitHeight,
                          width: 100,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        Tooltip(
                          height: 30,
                          message: 'Dark mode is ' +
                              (isDarkMode ? 'enabled' : 'disabled') +
                              '.',
                          child: DayNightSwitcher(
                              isDarkModeEnabled: isDarkMode,
                              onStateChanged: themeModeChanged),
                        ),
                        SizedBox(
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
        // const viewerAppBar(),
        //리사이즈드 위젯에서 박스.다트 에러 나는듯..
        //겟엑스로메뉴사이즈 조절하게 하려는데 안됨.
        body: ResizableWidget(percentages: [
          Get.find<LeftMenuCtrl>().activateLeftMenu.value == true ? 0.125 : 0,
          Get.find<LeftMenuCtrl>().activateLeftMenu.value == true ? 0.875 : 1
        ], children: [
          Container(
            color: Colors.pink,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Wavelength 1'),
                  ],
                ),
                Row(
                  children: [
                    SfSlider(
                      min: 50,
                      max: 100,
                      value: _value,
                      interval: 20,
                      onChanged: (dynamic value) {
                        setState(() {
                          _value = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Text('Wavelength 2'),
                Row(
                  children: [
                    SfSlider(
                      min: 0,
                      max: 100,
                      value: _value,
                      interval: 20,
                      onChanged: (dynamic value) {
                        setState(() {
                          _value = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Wavelength 3'),
                  ],
                ),
                SfSlider(
                  min: 0,
                  max: 100,
                  value: _value,
                  interval: 20,
                  onChanged: (dynamic value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Wavelength 4'),
                  ],
                ),
                SfSlider(
                  min: 0,
                  max: 100,
                  value: _value,
                  interval: 20,
                  onChanged: (dynamic value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                Text('Wavelength 5'),
                SfSlider(
                  min: 0,
                  max: 100,
                  value: _value,
                  interval: 20,
                  onChanged: (dynamic value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
              ],
            ),
          ),
          ResizableWidget(
            //드래그 드롭 && 타임셀렉트 하는 부분 공간 줄이는 라인
            isHorizontalSeparator: true,
            separatorColor: Colors.blueGrey,
            children: [
              Container(),
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
                            SizedBox(
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
                                            child: Text('File List')),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: const Color(0xffFF9110)),
                                          onPressed: () async {
                                            var myFiles = await FilePickerCross
                                                .importMultipleFromStorage(
                                              type: FileTypeCross.custom,
                                              fileExtension: 'csv',
                                            );
                                            print(
                                                '오픈한 파일리스트  :  ${myFiles.toList()}');

                                            print(
                                                '선택된 파일 갯수 : ${myFiles.length}');
                                          },
                                          child: Text('File select'),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary:
                                                    const Color(0xffD83737)),
                                            onPressed: () {},
                                            child: Text('File Delete')),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary:
                                                    const Color(0xffD83737)),
                                            onPressed: () {},
                                            child: Text('All File Delete')),
                                        SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Text('File num : 100'),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                            //파일 셀렉트하면 파일 나타나는 구간.
                            Expanded(
                              flex: 3,
                              child: FileList(),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Color(0xff5AEDCA)),
                                        onPressed: () {
                                          print('데이터를 차트로 보내기');
                                        },
                                        child: Text(
                                          'File load',
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
                              color: Colors.blueGrey.withOpacity(0.5),
                              width: 2),
                        ),
                        child: const Center(
                          child: TimeSelectTxtForm(),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
            percentages: const [0.8, 0.2],
          ),
        ]),
      ),
    );
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
}

class DarkModeCtrl extends GetxController {
  static DarkModeCtrl get to => Get.find();
  RxBool isDarkModeEnabled = false.obs;
}

class LeftMenuCtrl extends GetxController {
  static LeftMenuCtrl get to => Get.find();
  RxBool activateLeftMenu = true.obs;
}
