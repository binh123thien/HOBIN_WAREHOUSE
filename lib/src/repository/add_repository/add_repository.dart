import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/features/dashboard/models/themdonhang_model.dart';

import '../../features/dashboard/controllers/add/chonhanghoa_controller.dart';

class AddRepository extends GetxController {
  static AddRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  final ChonHangHoaController chonHangHoaController = Get.find();

  //get số lượng tồn kho cũ của hàng hóa đó
  Future<int> getTonKho(String docMaCode) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final snapshot = await _db
        .collection('Users')
        .doc(firebaseUser!.uid)
        .collection('Goods')
        .doc(firebaseUser.uid)
        .collection('HangHoa')
        .doc(docMaCode)
        .get();
    return snapshot.get('tonkho');
  }

  //update số lượng tồn kho bên collection HangHoa
  updateTonKho(String docMaCode, int tongTonKho, int soLuongBan) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    await _db
        .collection('Users')
        .doc(firebaseUser!.uid)
        .collection('Goods')
        .doc(firebaseUser.uid)
        .collection('HangHoa')
        .doc(docMaCode)
        .update({
      'tonkho': tongTonKho,
      'daban': soLuongBan,
    });
  }

  //=============================== Thêm hàng hóa mới =============================================
  // Lưu trữ good trên firestore
  createDonBanHang(ThemDonHangModel donbanhang) async {
    List<dynamic> filteredList = chonHangHoaController.allHangHoaFireBase
        .where((element) => element["soluong"] > 0)
        .toList();
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final banHangCollectionRef = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection("BanHang")
        .doc(donbanhang.soHD);
    // Tạo một document mới trong BanHang
    await banHangCollectionRef.set(donbanhang.toJson()).whenComplete(() =>
        Get.snackbar("Thành công", "Tạo đơn hàng thành công",
            colorText: Colors.green));
    // Do set trả dữ liệu về nên phải qua thêm phương thức get qua doc() vừa tạo
    final newDonBanHangDocSnapshot = await banHangCollectionRef.get();
    // Thêm một collection HoaDon vào document mới vừa tạo
    final hoaDonCollectionRef =
        newDonBanHangDocSnapshot.reference.collection("HoaDon");
    // Thêm các sản phẩm trong allHangHoa vào collection HoaDon
    for (var product in filteredList) {
      await hoaDonCollectionRef.add({
        "tensanpham": product["tensanpham"],
        "soluong": product["soluong"],
        "giaban": product["giaban"],
      });
      // Lấy số lượng tồn kho hiện tại của mặt hàng.
      int tonKhoHienTai = await getTonKho(product['macode']);
      //update thêm số lượng hàng vào tồn kho của hàng hóa đó
      int soluongTonKhoMoi =
          tonKhoHienTai - int.parse(product['soluong'].toString());
      updateTonKho(product['macode'], soluongTonKhoMoi,
          int.parse(product['soluong'].toString()));
    }
  }
//============================ end thêm đơn bán hàng ============================

//=============================== Nhập hàng =======================================
  createDonNhapHang(ThemDonHangModel donnhaphang) async {
    List<dynamic> filteredList = chonHangHoaController.allHangHoaFireBase
        .where((element) => element["soluong"] > 0)
        .toList();
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final nhapHangCollectionRef = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection("NhapHang")
        .doc(donnhaphang.soHD);
    // Tạo một document mới trong NhapHang
    await nhapHangCollectionRef.set(donnhaphang.toJson()).whenComplete(() =>
        Get.snackbar("Thành công", "Tạo đơn hàng thành công",
            colorText: Colors.green));

    // Do set trả dữ liệu về nên phải qua thêm phương thức get qua doc() vừa tạo
    final newDonNhapHangDocSnapshot = await nhapHangCollectionRef.get();
    // Thêm một collection HoaDon vào document mới vừa tạo
    final hoaDonCollectionRef =
        newDonNhapHangDocSnapshot.reference.collection("HoaDon");

    // Thêm các sản phẩm trong allHangHoa vào collection HoaDon
    for (var product in filteredList) {
      await hoaDonCollectionRef.add({
        "tensanpham": product["tensanpham"],
        "soluong": product["soluong"],
        "gianhap": product["gianhap"],
      });
      // Lấy số lượng tồn kho hiện tại của mặt hàng.
      int tonKhoHienTai = await getTonKho(product['macode']);
      //update thêm số lượng hàng vào tồn kho của hàng hóa đó
      int soluongTonKhoMoi =
          tonKhoHienTai + int.parse(product['soluong'].toString());
      updateTonKho(product['macode'], soluongTonKhoMoi, 0);
    }
  }
}
