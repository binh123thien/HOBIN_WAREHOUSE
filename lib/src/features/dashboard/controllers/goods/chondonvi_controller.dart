import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../repository/goods_repository/good_repository.dart';
import '../../models/donvi_model.dart';

class ChonDonViController extends GetxController {
  // static ChonDonViController get instance => Get.find();
  final controllerGoodRepo = Get.put(GoodRepository());

  final _db = FirebaseFirestore.instance;

  List<dynamic> allDonViFirebase = [].obs;

  loadDonVi() async {
    var snapshot = await controllerGoodRepo.getAlldonvi().first;
    allDonViFirebase =
        snapshot.docs.map((doc) => doc['donvi'].toString()).toList();
  }

  createDonViMoi(String searchnhapdonvi) {
    var donvimoi = DonViModel(donvi: searchnhapdonvi);
    //Tạo thằng được nhập trong thanh tìm kiếm lên db
    controllerGoodRepo.createDonViFirestore(donvimoi);
    loadDonVi();
  }

//========================== Tìm UID theo tên sau đó Delete theo UID ===============================================
  // Tìm DonVi đã chọn theo tên để tìm được UID
  Future<void> deleteDonviByTen(String tendonViDelete) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final QuerySnapshot snapshot = await _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("DonVi")
        .where("donvi", isEqualTo: tendonViDelete)
        .get();
    //Get được Donvi theo ten donvi
    final List<QueryDocumentSnapshot> docs = snapshot.docs;
    if (docs.isNotEmpty) {
      final String donviID = docs.first.id;
      await deleteDonVi(donviID);
    } else {
      print("Không tìm thấy đơn vị với tên tương ứng.");
    }
  }

  deleteDonVi(String docDelete) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    await _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("DonVi")
        .doc(docDelete)
        .delete()
        .whenComplete(() {
      Get.snackbar("Xóa thành công", "Đơn vị đã được xóa khỏi danh sách",
          colorText: Colors.green);
      loadDonVi();
    });
  }
//======================================= End Delete =============================================
}
