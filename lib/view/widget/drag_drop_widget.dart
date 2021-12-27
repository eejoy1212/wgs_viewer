import 'dart:math';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:get/get.dart';

class DragDropWidget extends StatefulWidget {
  const DragDropWidget({Key? key}) : super(key: key);

  @override
  _DragDropWidgetState createState() => _DragDropWidgetState();
}

class _DragDropWidgetState extends State<DragDropWidget> {
  // final RxList<List<XFile>> _fileList = RxList.empty();
  final List<XFile> _fileList = [];

  bool _dragging = false;

  Offset? offset;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      enable: true,
      onDragDone: (detail) {
        setState(() {
          _fileList.addAll(detail.urls.map((e) => XFile(e.path)));
        });
      },
      onDragUpdated: (details) {
        setState(() {
          offset = details.localPosition;
        });
      },
      onDragEntered: (detail) {
        setState(() {
          _dragging = true;
          offset = detail.localPosition;
        });
      },
      onDragExited: (detail) {
        setState(() {
          _dragging = false;
          offset = null;
        });
      },
      child: Container(
        height: 200,
        width: 200,
        color: _dragging ? Colors.blue.withOpacity(0.4) : Colors.black26,
        child: Stack(
          children: [
            if (_fileList.isEmpty)
              const Center(child: Text("Drop here"))
            else

              //아이콘도 리스트로 나오게 하기.

              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: InkWell(
                  onTap: () {},
                  child: Text(_fileList.map((data) => data.name).join("\n\n")),
                ),
              ),
            if (offset != null)
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '파일을 놓으세요',
                  style: Theme.of(context).textTheme.caption,
                ),
              )
          ],
        ),
      ),
    );
  }
}
