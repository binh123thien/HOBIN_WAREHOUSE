import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/features/authentication/models/user_models.dart';
import 'package:hobin_warehouse/src/repository/authentication_repository/authentication_repository.dart';
import 'package:hobin_warehouse/src/repository/user_repository/user_repository.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  // TextFeild Controller lấy dữ liệu từ TextForm
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmpass = TextEditingController();
  final userRepo = Get.put(UserRepository());

  //hàm đưa dữ liệu lên database
  void registerUser(String email, String password) {
    AuthenticationRepository.instance
        .createUserWithEmailAndPassword(email, password);
  }

  Future<void> createUserFireStore(UserModel user) async {
    await userRepo.createUserFireStore(user);
  }

  //Xac thuc Dang ky OTP
  // void phoneAuthentication(String phoneNo) {
  //   AuthenticationRepository.instance.phoneAuthentication(phoneNo);
  // }

  //
}
