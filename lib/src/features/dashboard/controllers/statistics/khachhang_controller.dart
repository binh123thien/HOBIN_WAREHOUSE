import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../repository/statistics_repository/khachhang_repository.dart';

class KhachHangController extends GetxController {
  static KhachHangController get instance => Get.find();

  TextEditingController tenKhachHangController = TextEditingController();
  TextEditingController sDTKhachHangController = TextEditingController();
  TextEditingController diaChiKhachHangController = TextEditingController();
  TextEditingController sortbyKhachHangController = TextEditingController();
  TextEditingController sortbyKhachNoController = TextEditingController();
  TextEditingController sortbyDonNoController = TextEditingController();

  final controllerKhachHangRepo = Get.put(KhachHangRepository());
  List<dynamic> allKhachHangFirebase = [].obs;
  List<dynamic> allDonBanHangFirebase = [].obs;
  List<dynamic> allDonNhapHangFirebase = [].obs;
  List<dynamic> allLichSuTraNoFirebase = [].obs;
  List<dynamic> allTongSanPhamTrongNgay = [].obs;
  loadAllKhachHang() async {
    await controllerKhachHangRepo.getAllKhachHang().listen((snapshot) {
      allKhachHangFirebase = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  loadAllDonXuatHang() async {
    await controllerKhachHangRepo.getAllDonHang("XuatHang").listen((snapshot) {
      allDonBanHangFirebase = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  loadAllDonNhapHang() async {
    await controllerKhachHangRepo.getAllDonHang("NhapHang").listen((snapshot) {
      allDonNhapHangFirebase = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  loadAllLichSuTraNo() async {
    await controllerKhachHangRepo
        .getAllDonHang("LichSuTraNo")
        .listen((snapshot) {
      allLichSuTraNoFirebase = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> loadAllTongSanPhamTrongNgay(
      List<dynamic> allDonHangTrongNgay) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    Map<String, Map<String, dynamic>> sanPhamVaSoLuongVaGiaBan = {};

    // Lặp qua các tài liệu của allDonHangTrongNgay.
    for (var doc in allDonHangTrongNgay) {
      String? soHD = doc["soHD"];
      // Tìm các tài liệu trong HoaDon collection phù hợp với số HD.
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(firebaseUser!.uid)
          .collection("History")
          .doc(firebaseUser.uid)
          .collection("BanHang")
          .doc(soHD)
          .collection("HoaDon")
          .get();

      // Lặp qua các tài liệu trong querySnapshot.
      for (var item in querySnapshot.docs) {
        String? tenSanPham = item["tensanpham"];
        num soLuong = item["soluong"];
        num giaBan = item["giaban"];

        if (tenSanPham != null) {
          // Kiểm tra xem sản phẩm đã được thêm vào từ trước hay chưa.
          if (!sanPhamVaSoLuongVaGiaBan.containsKey(tenSanPham)) {
            sanPhamVaSoLuongVaGiaBan[tenSanPham] = {"soLuong": 0, "giaBan": 0};
          }
          // Cập nhật giá trị cho sản phẩm.
          sanPhamVaSoLuongVaGiaBan[tenSanPham]!["soLuong"] += soLuong;
          sanPhamVaSoLuongVaGiaBan[tenSanPham]!["giaBan"] = giaBan;
        }
      }
    }

    // Chuyển đổi Map thành List<dynamic> với dạng [{pepsitt: 3, giaBan: 90000.0}].
    List<dynamic> ketQua = sanPhamVaSoLuongVaGiaBan.entries
        .map((e) => {e.key: e.value["soLuong"], "giaBan": e.value["giaBan"]})
        .toList();
    // Sắp xếp kết quả theo giá trị "soLuong" giảm dần.
    ketQua.sort((a, b) => b.values.first.compareTo(a.values.first));
    allTongSanPhamTrongNgay.assignAll(ketQua);
  }
}
