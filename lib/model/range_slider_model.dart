import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WGSrangeSlider {
  Rx<RangeValues> rv;
  List<dynamic> wls;
  RxDouble vStart;
  RxDouble vEnd;
  WGSrangeSlider({
    required this.rv,
    required this.wls,
    required this.vStart,
    required this.vEnd,
  });

  WGSrangeSlider copyWith({
    Rx<RangeValues>? rv,
    List<dynamic>? wls,
    RxDouble? vStart,
    RxDouble? vEnd,
  }) {
    return WGSrangeSlider(
      rv: rv ?? this.rv,
      wls: wls ?? this.wls,
      vStart: vStart ?? this.vStart,
      vEnd: vEnd ?? this.vEnd,
    );
  }

  @override
  String toString() {
    return 'WGSrangeSlider(rv: $rv, wls: $wls, vStart: $vStart, vEnd: $vEnd)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WGSrangeSlider &&
        other.rv == rv &&
        listEquals(other.wls, wls) &&
        other.vStart == vStart &&
        other.vEnd == vEnd;
  }

  @override
  int get hashCode {
    return rv.hashCode ^ wls.hashCode ^ vStart.hashCode ^ vEnd.hashCode;
  }
}
