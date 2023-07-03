import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/features/dashboard/models/themdonhang_model.dart';
import 'package:intl/intl.dart';

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
  createDonBanHang(
      ThemDonHangModel donbanhang, List<dynamic> filteredList) async {
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

  Future<void> createTongDoanhThuNgay(String ngay, num doanhthu, num no) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final docRef = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection("TongDoanhThu")
        .doc(firebaseUser.uid)
        .collection("HangNgay")
        .doc(ngay);

    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Nếu tài liệu đã tồn tại, cộng trường doanhthu lại
      final existingDoanhThu = docSnapshot.data()?['doanhthu'] ?? 0;
      final newDoanhThu = existingDoanhThu + doanhthu;

      await docRef.update({'doanhthu': newDoanhThu});

      if (no == 0) {
        await docRef.update({'thanhcong': FieldValue.increment(1)});
      } else if (no > 0) {
        await docRef.update({'dangcho': FieldValue.increment(1)});
      }
    } else {
      // Nếu tài liệu chưa tồn tại, tạo mới tài liệu với trường doanhthu và các trường khác
      await docRef.set({
        'doanhthu': doanhthu,
        'thanhcong': no == 0 ? 1 : 0,
        'dangcho': no > 0 ? 1 : 0,
        'huy': 0
      });
    }
  }

  Future<void> createTongDoanhThuTuan(String ngay, num doanhthu, num no) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final docRef = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection("TongDoanhThu")
        .doc(firebaseUser.uid)
        .collection("HangTuan");

    final tuanNgay = getTuanFromDate(ngay);

    final docSnapshot = await docRef.doc(tuanNgay).get();

    if (docSnapshot.exists) {
      // Nếu tài liệu đã tồn tại, cộng trường doanhthu lại
      final existingDoanhThu = docSnapshot.data()?['doanhthu'] ?? 0;
      final newDoanhThu = existingDoanhThu + doanhthu;

      await docRef.doc(tuanNgay).update({'doanhthu': newDoanhThu});

      if (no == 0) {
        await docRef
            .doc(tuanNgay)
            .update({'thanhcong': FieldValue.increment(1)});
      } else if (no > 0) {
        await docRef.doc(tuanNgay).update({'dangcho': FieldValue.increment(1)});
      }
    } else {
      // Nếu tài liệu chưa tồn tại, tạo mới tài liệu với trường doanhthu và các trường khác
      await docRef.doc(tuanNgay).set({
        'doanhthu': doanhthu,
        'thanhcong': no == 0 ? 1 : 0,
        'dangcho': no > 0 ? 1 : 0,
        'huy': 0
      });
    }
  }

  String getTuanFromDate(String ngay) {
    final dateFormat = DateFormat("dd-MM-yyyy");
    final date = dateFormat.parse(ngay);

    // Tạo ra một DateTime của ngày đầu tiên của năm
    final startOfYear = DateTime(date.year, 1, 1);

    // Tính toán số ngày kể từ ngày đầu tiên của năm đến ngày cho trước
    final daysSinceStartOfYear = date.difference(startOfYear).inDays;

    // Tính toán tuần dựa trên số ngày đã trôi qua và tuần đầu tiên của năm
    final weekNumber = (daysSinceStartOfYear / 7).ceil();
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final tuanNgay =
        'Tuần $weekNumber (${dateFormat.format(startOfWeek).replaceAll("-", "Th").substring(0, 6)} - ${dateFormat.format(endOfWeek).replaceAll("-", "Th").substring(0, 6)})';
    return tuanNgay;
  }

  Future<void> createTongDoanhThuThang(
      String ngay, num doanhthu, num no) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final dateFormat = DateFormat("dd-MM-yyyy");
    final date = dateFormat.parse(ngay);

    // Tạo ra định dạng chuỗi "Tháng MM-yyyy" từ ngày cho trước
    final monthFormat = DateFormat("'Tháng' MM-yyyy");
    final monthString = monthFormat.format(date);

    final docRef = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection("TongDoanhThu")
        .doc(firebaseUser.uid)
        .collection("HangThang")
        .doc(monthString);

    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Nếu tài liệu đã tồn tại, cộng trường doanhthu lại
      final existingDoanhThu = docSnapshot.data()?['doanhthu'] ?? 0;
      final newDoanhThu = existingDoanhThu + doanhthu;

      await docRef.update({'doanhthu': newDoanhThu});

      if (no == 0) {
        await docRef.update({'thanhcong': FieldValue.increment(1)});
      } else if (no > 0) {
        await docRef.update({'dangcho': FieldValue.increment(1)});
      }
    } else {
      // Nếu tài liệu chưa tồn tại, tạo mới tài liệu với trường doanhthu và các trường khác
      await docRef.set({
        'doanhthu': doanhthu,
        'thanhcong': no == 0 ? 1 : 0,
        'dangcho': no > 0 ? 1 : 0,
        'huy': 0
      });
    }
  }
}
