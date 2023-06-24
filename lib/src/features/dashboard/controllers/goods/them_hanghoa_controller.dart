import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemHangHoaController extends GetxController {
  static ThemHangHoaController get instance => Get.find();

  // TextFeild Controller lấy dữ liệu từ TextForm
  TextEditingController phanloaiController = TextEditingController();
  TextEditingController maCodeController = TextEditingController();
  TextEditingController tenSanPhamController = TextEditingController();
  TextEditingController gianhapController = TextEditingController();
  TextEditingController giabanController = TextEditingController();
  TextEditingController danhMucController = TextEditingController();
  TextEditingController donviController = TextEditingController();

  final searchController = TextEditingController();

  final sortbyhanghoaController = TextEditingController();
  final sortbyhanghoaTaoDonController = TextEditingController();
}
