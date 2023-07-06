import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NoRepository extends GetxController {
  static NoRepository get instance => Get.find();
  List<dynamic> foundDocs = [].obs;
  Future<List> timlaikhachhang(List<dynamic> filteredList) async {
    List<dynamic> foundDocs = [];
    final firebaseUser = FirebaseAuth.instance.currentUser;
    for (var filteredDoc in filteredList) {
      var tenkhachhang = filteredDoc["khachhang"];
      var docs = await FirebaseFirestore.instance
          .collection("Users")
          .doc(firebaseUser!.uid)
          .collection("Statistics")
          .doc(firebaseUser.uid)
          .collection("KhachHang")
          .where("tenkhachhang", isEqualTo: tenkhachhang)
          .get();
      foundDocs.addAll(docs.docs.map((doc) => doc.data()));
    }
    return foundDocs;
  }

  updateTrangThaiNgaySauKhiTraNo(String ngay, num no, String option) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final db = FirebaseFirestore.instance;
    final docRef = db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection("TongDoanhThu")
        .doc(firebaseUser.uid)
        .collection("HangNgay")
        .doc(ngay);
    if (option == "traNoLonHonNo") {
      await docRef.update({
        'dangcho': FieldValue.increment(-1),
        'thanhcong': FieldValue.increment(1),
        'doanhthu': FieldValue.increment(no),
      });
    } else if (option == "traNoNhoHonNo") {
      await docRef.update({
        'doanhthu': FieldValue.increment(no),
      });
    }
  }

  updateTrangThaiTuanSauKhiTraNo(String ngay, num no, String option) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final db = FirebaseFirestore.instance;
    final docRef = db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection("TongDoanhThu")
        .doc(firebaseUser.uid)
        .collection("HangTuan")
        .doc(getTuanFromDate(ngay));
    if (option == "traNoLonHonNo") {
      await docRef.update({
        'dangcho': FieldValue.increment(-1),
        'thanhcong': FieldValue.increment(1),
        'doanhthu': FieldValue.increment(no),
      });
    } else if (option == "traNoNhoHonNo") {
      await docRef.update({
        'doanhthu': FieldValue.increment(no),
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

  updateTrangThaiThangSauKhiTraNo(String ngay, num no, String option) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final db = FirebaseFirestore.instance;
    final dateFormat = DateFormat("dd-MM-yyyy");
    final date = dateFormat.parse(ngay);

    // Tạo ra định dạng chuỗi "Tháng MM-yyyy" từ ngày cho trước
    final monthFormat = DateFormat("MM-yyyy");
    final monthString = monthFormat.format(date);

    final docRef = db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection("TongDoanhThu")
        .doc(firebaseUser.uid)
        .collection("HangThang")
        .doc(monthString);
    if (option == "traNoLonHonNo") {
      await docRef.update({
        'dangcho': FieldValue.increment(-1),
        'thanhcong': FieldValue.increment(1),
        'doanhthu': FieldValue.increment(no),
      });
    } else if (option == "traNoNhoHonNo") {
      await docRef.update({
        'doanhthu': FieldValue.increment(no),
      });
    }
  }
}
