import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RangeSliderModel {
  Rx<RangeValues> rv;
  List<dynamic> wls;
  RxDouble vStart;
  RxDouble vEnd;
  Rx<bool> isChecked;
  Rx<int> index;
  RangeSliderModel({
    required this.rv,
    required this.wls,
    required this.vStart,
    required this.vEnd,
    required this.isChecked,
    required this.index,
  });

  RangeSliderModel copyWith({
    Rx<RangeValues>? rv,
    List<dynamic>? wls,
    RxDouble? vStart,
    RxDouble? vEnd,
    Rx<bool>? isChecked,
    Rx<int>? index,
  }) {
    return RangeSliderModel(
      rv: rv ?? this.rv,
      wls: wls ?? this.wls,
      vStart: vStart ?? this.vStart,
      vEnd: vEnd ?? this.vEnd,
      isChecked: isChecked ?? this.isChecked,
      index: index ?? this.index,
    );
  }

  @override
  String toString() {
    return 'RangeSliderModel(rv: $rv, wls: $wls, vStart: $vStart, vEnd: $vEnd, isChecked: $isChecked, index: $index)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RangeSliderModel &&
        other.rv == rv &&
        listEquals(other.wls, wls) &&
        other.vStart == vStart &&
        other.vEnd == vEnd &&
        other.isChecked == isChecked &&
        other.index == index;
  }

  @override
  int get hashCode {
    return rv.hashCode ^
        wls.hashCode ^
        vStart.hashCode ^
        vEnd.hashCode ^
        isChecked.hashCode ^
        index.hashCode;
  }
}
