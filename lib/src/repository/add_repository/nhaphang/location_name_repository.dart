import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationNameRepo extends GetxController {
  static LocationNameRepo get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  getAllLocationName() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final getAllLocationName = FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("LocationName")
        .snapshots();
    return getAllLocationName;
  }

  createLocationName(String vitri) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    await _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("LocationName")
        .add({'id': vitri}).whenComplete(() => Get.snackbar(
            "Thành công", "Đã thêm vị trí mới vào danh sách",
            colorText: Colors.green));
    // controllerLocation.allLocationNameFirebase.add({'id': vitri});
  }
}
