import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/features/dashboard/models/danhmuc_model.dart';
import '../../../../repository/goods_repository/good_repository.dart';

class ChonDanhMucController extends GetxController {
  // static ChonDonViController get instance => Get.find();
  final controllerGoodRepo = Get.put(GoodRepository());

  final _db = FirebaseFirestore.instance;

  List<dynamic> allDanhMucFirebase = [].obs;

  //List lưu trữ các item được chọn trong List Danh Mục
  RxList<String> selectedDanhMuc = RxList<String>();

  loadDanhMuc() async {
    var snapshot = await controllerGoodRepo.getAlldanhmuc().first;
    allDanhMucFirebase =
        snapshot.docs.map((doc) => doc['danhmuc'].toString()).toList();
  }

  createDanhMucMoi(String searchdanhmuc) {
    var danhmucmoi = DanhMucModel(danhmuc: searchdanhmuc);
    //Tạo thằng được nhập trong thanh tìm kiếm lên db
    controllerGoodRepo.createDanhMucFirestore(danhmucmoi);
    loadDanhMuc();
  }

//========================== Tìm UID theo tên sau đó Delete theo UID ===============================================
  // Tìm DonVi đã chọn theo tên để tìm được UID
  Future<void> deleteDanhMucByTen(String tendanhMucDelete) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final QuerySnapshot snapshot = await _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("DanhMuc")
        .where("danhmuc", isEqualTo: tendanhMucDelete)
        .get();
    //Get được Donvi theo ten donvi
    final List<QueryDocumentSnapshot> docs = snapshot.docs;
    if (docs.isNotEmpty) {
      final String donviID = docs.first.id;
      await deleteDanhMuc(donviID);
    } else {
      print("Không tìm thấy danh mục với tên tương ứng.");
    }
  }

  deleteDanhMuc(String docDelete) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    await _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("DanhMuc")
        .doc(docDelete)
        .delete()
        .whenComplete(() {
      Get.snackbar("Xóa thành công", "Danh mục đã được xóa khỏi danh sách",
          colorText: Colors.green);
      loadDanhMuc();
    });

    // where("donvi", isEqualTo: donViDelete).
  }
//======================================= End Delete =============================================
}
