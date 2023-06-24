import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/features/dashboard/models/danhmuc_model.dart';

import '../../features/authentication/models/user_models.dart';
import '../../features/dashboard/models/donvi_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  // Lưu trữ User trên firestore
  createUserFireStore(UserModel user) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    await _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .set(user.toJson())
        .whenComplete(() => Get.snackbar(
            "Tạo tài khoản thành công", "Chào mừng bạn đến với HOBIN!",
            colorText: Colors.green))
        .catchError((error, stackTrace) {
      Get.snackbar("Lỗi", "Tao TK that bai!", colorText: Colors.red);
    });
  }

  createDonViDefault(DonViModel donvi) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    await _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("DonVi")
        .add(donvi.toJson());
  }

  createDanhMucDefault(DanhMucModel danhmuc) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    await _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("DanhMuc")
        .add(danhmuc.toJson());
  }

  // // Bước 2 - Tìm thông tin của tất cả User hoặc 1
  // Future<UserModel> getUserDetails(String email) async {
  //   final snapshot =
  //       await _db.collection("Users").where("Email", isEqualTo: email).get();
  //   final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).first;
  //   print(userData.toJson());
  //   return userData;
  // }

  // Future<List<UserModel>> allUser() async {
  //   final snapshot = await _db.collection("Users").get();
  //   final userData =
  //       snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
  //   return userData;
  // }

  //hàm update
  Future<void> updateUserRecord(UserModel user) async {
    await _db.collection("Users").doc(user.id).update({"Name": "Bình123456"});
  }
}
