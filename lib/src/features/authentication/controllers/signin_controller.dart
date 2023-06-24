import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/repository/authentication_repository/authentication_repository.dart';
import 'package:hobin_warehouse/src/repository/user_repository/user_repository.dart';

class SignInController extends GetxController {
  static SignInController get instance => Get.find();

  // TextFeild Controller lấy dữ liệu từ TextForm
  final email = TextEditingController();
  final password = TextEditingController();

  final userRepo = Get.put(UserRepository());

  //hàm đưa dữ liệu lên database
  void signinWithEmailAndPassword(String email, String password) {
    AuthenticationRepository.instance
        .signinWithEmailAndPassword(email, password);
  }

  void signinWithGoogle() {
    AuthenticationRepository.instance.signinWithGoogle();
  }
}
