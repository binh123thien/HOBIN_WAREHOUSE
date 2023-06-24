import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/repository/authentication_repository/authentication_repository.dart';

class ForgetPassController extends GetxController {
  static ForgetPassController get instance => Get.find();

  // TextFeild Controller lấy dữ liệu từ TextForm
  final password = TextEditingController();

  //hàm đưa dữ liệu lên database
  void resetPassword(String email) {
    AuthenticationRepository.instance.resetPassword(email);
  }
}
