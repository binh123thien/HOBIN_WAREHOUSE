import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NhapHangController extends GetxController {
  static NhapHangController get instance => Get.find();
  TextEditingController giamgiaNhapHangController = TextEditingController();
  TextEditingController noNhapHangController = TextEditingController();
}
