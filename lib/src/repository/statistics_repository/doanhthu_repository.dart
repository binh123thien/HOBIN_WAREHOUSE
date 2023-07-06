import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DoanhThuRepository extends GetxController {
  static DoanhThuRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  getTongDoanhThuNgay() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final getTongDoanhThuNgay = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection("TongDoanhThu")
        .doc(firebaseUser.uid)
        .collection("HangNgay")
        .orderBy("day", descending: true)
        .limit(30)
        .snapshots();
    return getTongDoanhThuNgay;
  }

  getTongDoanhThuTuan() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final getTongDoanhThuTuan = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection("TongDoanhThu")
        .doc(firebaseUser.uid)
        .collection("HangTuan")
        .orderBy("week", descending: true)
        .limit(30)
        .snapshots();
    return getTongDoanhThuTuan;
  }

  getTongDoanhThuThang() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final getTongDoanhThuTuan = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection("TongDoanhThu")
        .doc(firebaseUser.uid)
        .collection("HangThang")
        .orderBy("month", descending: true)
        .limit(30)
        .snapshots();
    return getTongDoanhThuTuan;
  }
}
