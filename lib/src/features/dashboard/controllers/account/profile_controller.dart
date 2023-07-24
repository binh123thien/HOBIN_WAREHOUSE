import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/features/authentication/models/user_models.dart';
import 'package:hobin_warehouse/src/repository/authentication_repository/authentication_repository.dart';
import 'package:hobin_warehouse/src/repository/user_repository/user_repository.dart';

class ProfileController extends GetxController {
  //tìm ProfileController trong những file khác có PUT
  static ProfileController get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneController => _phoneController;

// để gọi hàm trong Repository
  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  //tạo model tạm
  UserModel userDataFrebase =
      UserModel(email: '', password: '', name: '', phone: '', photoURL: '');

  //Step 3 - Nhận User Email và đẩy sang UserRepository với user đã tìm thấy
  getUserData() {
    //lấy địa chỉ email ng dùng đăng nhập
    final email = _authRepo.firebaseUser.value?.email;
    if (email != null) {
      final snapshot =
          _db.collection("Users").where("Email", isEqualTo: email).snapshots();
      return snapshot;
    } else {
      Get.snackbar("Lỗi", "Đăng nhập để tiếp tục");
    }
  }

  // //hàm get all User
  // Future<List<UserModel>> getAllUsers() async => await _userRepo.allUser();

  // hàm update user
  updateRecord(UserModel user) async {
    await _userRepo.updateUserRecord(user);
  }
}
