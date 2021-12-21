import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:resizable_widget/resizable_widget.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:wgs_viewer/checkbox_list_widget.dart';
import 'package:wgs_viewer/controller/chart_ctrl.dart';
import 'package:wgs_viewer/controller/dark_mode_ctrl.dart';
import 'package:wgs_viewer/controller/left_menu_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/model/checkbox_model.dart';
import 'package:wgs_viewer/time_select_widget.dart';
import 'package:wgs_viewer/window_btns.dart';

void main() {
  Get.put(LeftMenuCtrl());
  Get.put(DarkModeCtrl());
  Get.put(TimeSelectCtrl());
  Get.put(ChartCtrl());
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
                          SizedBox(
                            width: 220,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Row(
                              children: [
                                Text(
                                  'Chart Show Mode :  ',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Tooltip(
                                  message: 'Show only left chart',
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF15202B)),
                                    onPressed: () {
                                      Get.find<ChartCtrl>().visibleMode.value =
                                          0;
                                    },
                                    child: Text('left'),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Tooltip(
                                  message: 'Show only right chart',
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF15202B)),
                                    onPressed: () {
                                      Get.find<ChartCtrl>().visibleMode.value =
                                          1;
                                    },
                                    child: Text('Right'),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Tooltip(
                                  message: 'Show all chart',
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF15202B)),
                                    onPressed: () {
                                      Get.find<ChartCtrl>().visibleMode.value =
                                          2;
                                    },
                                    child: Text('All'),
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
          body: Obx(
            () =>
                ResizableWidget(separatorColor: Colors.blueGrey, percentages: [
              // Get.find<LeftMenuCtrl>().activateLeftMenu.value == true ? 0.125 : 0,
              // Get.find<LeftMenuCtrl>().activateLeftMenu.value == true ? 0.875 : 1,
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
                        Text('Wavelength 1'),
                        MaterialColorPicker(
                          circleSize: 150,
                          onColorChange: (Color color) {},
                          selectedColor: Colors.red,
                          colors: [
                            Colors.red,
                            Colors.deepOrange,
                            Colors.yellow,
                            Colors.lightGreen
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
                      ],
                    ),
                    Column(
                      children: [
                        Text('Wavelength 2'),
                        MaterialColorPicker(
                          circleSize: 150,
                          onColorChange: (Color color) {},
                          selectedColor: Colors.red,
                          colors: [
                            Colors.red,
                            Colors.deepOrange,
                            Colors.yellow,
                            Colors.lightGreen
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
                      ],
                    ),
                    Column(
                      children: [
                        Text('Wavelength 3'),
                        MaterialColorPicker(
                          circleSize: 150,
                          onColorChange: (Color color) {},
                          selectedColor: Colors.red,
                          colors: [
                            Colors.red,
                            Colors.deepOrange,
                            Colors.yellow,
                            Colors.lightGreen
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
                      ],
                    ),
                    Column(
                      children: [
                        Text('Wavelength 4'),
                        MaterialColorPicker(
                          circleSize: 150,
                          onColorChange: (Color color) {},
                          selectedColor: Colors.red,
                          colors: [
                            Colors.red,
                            Colors.deepOrange,
                            Colors.yellow,
                            Colors.lightGreen
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
                      ],
                    ),
                    Column(
                      children: [
                        Text('Wavelength 5'),
                        MaterialColorPicker(
                          circleSize: 150,
                          onColorChange: (Color color) {},
                          selectedColor: Colors.red,
                          colors: [
                            Colors.red,
                            Colors.deepOrange,
                            Colors.yellow,
                            Colors.lightGreen
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
                            visible: Get.find<ChartCtrl>().visibleMode.value ==
                                        0 ||
                                    Get.find<ChartCtrl>().visibleMode.value == 2
                                ? true
                                : false,
                            child: Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  //left Chat 클릭 하면, left Chart만 보이게 하기.
                                  Get.find<ChartCtrl>().visibleMode.value = 0;
                                },
                                onDoubleTap: () {
                                  //left Chat 더블 클릭 하면, 양쪽 차트 다 보이게 하기.
                                  Get.find<ChartCtrl>().visibleMode.value = 2;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    color: Colors.green,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(top: 300.0),
                                            child: Text(
                                              'left chart',
                                              style: TextStyle(fontSize: 30),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.blueAccent),
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.file_copy_outlined,
                                                  size: 20,
                                                ),
                                                label: Text('Export'),
                                              ),
                                            ],
                                          ),
                                        ]),
                                  ),
                                ),
                              ),
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
                              child: Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    //right Chat 클릭 하면, right Chart만 보이게 하기.
                                    Get.find<ChartCtrl>().visibleMode.value = 1;
                                  },
                                  onDoubleTap: () {
                                    //right Chat 더블 클릭 하면, 양쪽 차트 다 보이게 하기.
                                    Get.find<ChartCtrl>().visibleMode.value = 2;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      color: Colors.pink,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(top: 300.0),
                                            child: Text(
                                              'right chart',
                                              style: TextStyle(fontSize: 30),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.blueAccent),
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.file_copy_outlined,
                                                  size: 20,
                                                ),
                                                label: Text('Export'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
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
                                                  primary:
                                                      const Color(0xffFF9110)),
                                              onPressed: () async {
                                                List<String> paths =
                                                    await FilePickerCross
                                                        .listInternalFiles();
                                                var myFiles = await FilePickerCross
                                                    .importMultipleFromStorage(
                                                  type: FileTypeCross.custom,
                                                  fileExtension: 'csv',
                                                );
                                                // FilePickerCross.delete(path[0]);
                                                // myFiles.saveToPath('/my/awesome/folder/' + myFile.fileName);
                                                print(
                                                    '오픈한 파일리스트  :  ${myFiles.toList()}');
                                                print('파일들 경로 : ${paths}');
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
                                                    primary: const Color(
                                                        0xffD83737)),
                                                onPressed: () {},
                                                child: Text('File Delete')),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: const Color(
                                                        0xffD83737)),
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
                  ),
                ],
                percentages: const [
                  0.8,
                  0.2,
                ],
              ),
            ]),
          )),
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
