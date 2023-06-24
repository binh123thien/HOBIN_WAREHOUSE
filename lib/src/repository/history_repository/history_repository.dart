import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryRepository extends GetxController {
  static HistoryRepository get instance => Get.find();
  //table thanh toán
  List<dynamic> hoaDonPDFControler = [];
  //chi tiet thanh toan
  List<dynamic> chitietTThoaDonPDFControler = [];

  getAllDonBanHangHoacNhapHang(String collectionBanHangHoacNhapHang) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final getAllDonBanHang = FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection(collectionBanHangHoacNhapHang)
        .snapshots();
    return getAllDonBanHang;
  }

  getAllSanPhamTrongHoaDon(String docID, String collectionBanHangHoacNhapHang) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final getAllSanPhamTrongHoaDon = FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection(collectionBanHangHoacNhapHang)
        .doc(docID)
        .collection("HoaDon")
        .snapshots();
    return getAllSanPhamTrongHoaDon;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<List<List<DocumentSnapshot>>> getDocsByMonthly(
      String collectionName, String userID) async {
    try {
      final QuerySnapshot snapshot = await firestore
          .collection("Users")
          .doc(userID)
          .collection("History")
          .doc(userID)
          .collection(collectionName)
          .orderBy('soHD', descending: true) // add this line to sort by 'soHD'
          .get();

      // Group documents by month
      final Map<String, List<DocumentSnapshot>> docsByMonth = {};
      for (final doc in snapshot.docs) {
        final month = doc['ngaytao'].split('/')[1];
        if (!docsByMonth.containsKey(month)) {
          docsByMonth[month] = [doc];
        } else {
          docsByMonth[month]!.add(doc);
        }
      }

      // Sort document groups by month
      DateTime parseDateTime(String dateTimeStr) {
        final dateFormat = DateFormat('yyMMdd-hhMMss');
        return dateFormat.parse(dateTimeStr);
      }

      final docsByMonthly = docsByMonth.values.toList();
      docsByMonthly.sort((a, b) => parseDateTime(b.first['soHD'])
          .compareTo(parseDateTime(a.first['soHD'])));

      return docsByMonthly;
    } catch (e) {
      return [];
    }
  }

  Future<List<List<DocumentSnapshot>>> getDocsByMonthlyPhanLoai(
      String userID, String phanloai) async {
    try {
      final QuerySnapshot snapshot1 = await firestore
          .collection("Users")
          .doc(userID)
          .collection("History")
          .doc(userID)
          .collection("BanHang")
          .where('trangthai', isEqualTo: phanloai)
          .get();
      final QuerySnapshot snapshot2 = await firestore
          .collection("Users")
          .doc(userID)
          .collection("History")
          .doc(userID)
          .collection("NhapHang")
          .where('trangthai', isEqualTo: phanloai)
          .get();
      final List<DocumentSnapshot> documents = [];
      documents.addAll(snapshot1.docs);
      documents.addAll(snapshot2.docs);
      documents.sort((a, b) => b['soHD'].compareTo(a['soHD']));
      // Group documents by month
      final Map<String, List<DocumentSnapshot<Object?>>> docsByMonth = {};
      for (final doc in documents) {
        final month = doc['ngaytao'].split('/')[1];
        if (!docsByMonth.containsKey(month)) {
          docsByMonth[month] = [doc];
        } else {
          docsByMonth[month]!.add(doc);
        }
      }

      // Sort document groups by month
      DateTime parseDateTime(String dateTimeStr) {
        final dateFormat = DateFormat('yyMMdd-hhMMss');
        return dateFormat.parse(dateTimeStr);
      }

      final docsByMonthly = docsByMonth.values.toList();
      docsByMonthly.sort((a, b) => parseDateTime(b.first['soHD'])
          .compareTo(parseDateTime(a.first['soHD'])));

      return docsByMonthly;
    } catch (e) {
      return [];
    }
  }

  loadAllDonBanHangHoacNhapHang(String collectionBanHangHoacNhapHang) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final getAllDonBanHang = FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection(collectionBanHangHoacNhapHang)
        .get();
    return getAllDonBanHang;
  }
}
