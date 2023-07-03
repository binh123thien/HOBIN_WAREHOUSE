import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChonHangHoaLeController extends GetxController {
  static ChonHangHoaLeController get instance => Get.find();

  // TextFeild Controller lấy dữ liệu từ TextForm
  final soLuongLe = TextEditingController();
  final soLuongSi = TextEditingController();
}
