import 'package:get/get.dart';
import 'package:translator/translator.dart';

class TranslatorCtrl extends GetxController {
  static TranslatorCtrl get to => Get.find();
  RxString input = '..'.obs;
  RxString afterTrans = ''.obs;

  String korToEn() {
    final translator = GoogleTranslator();
    final input = TranslatorCtrl.to.input.value;
    // 한글을 영어로 번역하고싶으면 TranslatorCtrl.to.input=String타입변수 하고, korToEn함수 태우면 된다.
    translator
        .translate(TranslatorCtrl.to.input.string, to: 'en')
        .then((result) {
      print("Source: $input\nTranslated: $result");
      TranslatorCtrl.to.input.value = result.toString();
    });
    return TranslatorCtrl.to.input.value;
  }
}
