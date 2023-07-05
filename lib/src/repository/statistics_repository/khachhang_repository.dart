import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/dashboard/controllers/statistics/khachhang_controller.dart';
import '../../features/dashboard/models/statistics/themkhachhang_model.dart';

class KhachHangRepository extends GetxController {
  static KhachHangRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createKhachHangMoi(
      ThemKhachHangModel khachhang, String tenkhachhang, String maKH) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final snapshot = await checkKhachHang(tenkhachhang);
    if (snapshot.docs.isNotEmpty) {
      Get.snackbar("Thất bại", "Khách hàng đã có", colorText: Colors.red);
    } else {
      await _db
          .collection("Users")
          .doc(firebaseUser!.uid)
          .collection("Statistics")
          .doc(firebaseUser.uid)
          .collection("KhachHang")
          .doc(maKH)
          .set(khachhang.toJson())
          .whenComplete(() => Get.snackbar("Thành công", "Đã thêm khách hàng",
              colorText: Colors.green));
    }
  }

  checkKhachHang(String value) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    QuerySnapshot snapshot = await _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Statistics")
        .doc(firebaseUser.uid)
        .collection("KhachHang")
        .where('tenkhachhang', isEqualTo: value)
        .get();
    return snapshot;
  }

  Future<dynamic> updateKhachHang(String docID, String loai) async {
    final controllerForm = Get.put(KhachHangController());
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final snapshot =
        await checkKhachHang(controllerForm.tenKhachHangController.text);
    bool duplicateName =
        false; // Biến flag để kiểm tra tên khách hàng đã có hay chưa

    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        // doc.id != docID: nhập trùng tên thằng đã tồn tại (hiểu ngược là lụm TH ==)
        if (doc.id != docID &&
            doc["tenkhachhang"] == controllerForm.tenKhachHangController.text) {
          duplicateName = true;
          break;
        }
      }
    }

    if (duplicateName) {
      Get.snackbar("Thất bại", "Khách hàng đã có", colorText: Colors.red);
    } else {
      await _db
          .collection("Users")
          .doc(firebaseUser!.uid)
          .collection("Statistics")
          .doc(firebaseUser.uid)
          .collection("KhachHang")
          .doc(docID)
          .update({
        "tenkhachhang": controllerForm.tenKhachHangController.text,
        "sdt": controllerForm.sDTKhachHangController.text,
        "diachi": controllerForm.diaChiKhachHangController.text,
        "loai": loai
      }).whenComplete(() => Get.snackbar(
              "Thành công", "Cập nhật khách hàng thành công",
              colorText: Colors.green));
    }
    // Lấy doc mới cập nhật return về
    final updatedDoc = await _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Statistics")
        .doc(firebaseUser.uid)
        .collection("KhachHang")
        .doc(docID)
        .get();
    return updatedDoc.data();
  }

  getAllKhachHang() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final getKhachHang = FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Statistics")
        .doc(firebaseUser.uid)
        .collection("KhachHang")
        .snapshots();
    return getKhachHang;
  }

  Future<void> deleteKhachHang(String docId) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(firebaseUser!.uid)
        .collection("Statistics")
        .doc(firebaseUser.uid)
        .collection("KhachHang")
        .doc(docId)
        .delete()
        .whenComplete(() => Get.snackbar(
            "Thành công", "Xóa khách hàng thành công",
            colorText: Colors.green));
  }

  sortbyKhachHang(List<dynamic> allItems, String controller) {
    if (controller == "Khách hàng") {
      return allItems.where((item) => item["loai"] == "Khách hàng").toList();
    } else if (controller == "Nhà cung cấp") {
      return allItems.where((item) => item["loai"] == "Nhà cung cấp").toList();
      // =========================sort by No ============================//
    } else if (controller == "Khách Hàng") {
      return allItems.where((item) => item["billType"] == "BanHang").toList();
    } else if (controller == "Nhà Cung Cấp") {
      return allItems.where((item) => item["billType"] == "NhapHang").toList();
    } else if (controller == "Nợ tăng dần") {
      allItems.sort((a, b) => a["no"].compareTo(b["no"]));
      return allItems;
    } else if (controller == "Nợ giảm dần") {
      allItems.sort((b, a) => a["no"].compareTo(b["no"]));
      return allItems;
    } else if (controller == "A=>Z") {
      allItems.sort((a, b) =>
          a["khachhang"].toLowerCase().compareTo(b["khachhang"].toLowerCase()));
      return allItems;
    } else if (controller == "Z=>A") {
      allItems.sort((b, a) =>
          a["khachhang"].toLowerCase().compareTo(b["khachhang"].toLowerCase()));
      return allItems;
    } else {
      return allItems;
    }
  }

  // ===================================== xu ly data ==========================================//
  Future<List<DocumentSnapshot>> getDocsByKhachHang(
      String collectionName, String tenkhachhang) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(firebaseUser!.uid)
          .collection("History")
          .doc(firebaseUser.uid)
          .collection(collectionName)
          .where('khachhang', isEqualTo: tenkhachhang)
          .get();
      final List<DocumentSnapshot> documents = [];
      documents.addAll(snapshot.docs);
      documents.sort((a, b) => b['soHD'].compareTo(a['soHD']));
      return documents;
    } catch (e) {
      return [];
    }
  }

  getAllDonHang(String loaidonhang) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final getDonHang = FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection(loaidonhang)
        .snapshots();
    return getDonHang;
  }
}
