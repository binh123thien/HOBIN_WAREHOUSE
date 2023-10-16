import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../features/dashboard/models/themdonhang_model.dart';

class HetHanRepository extends GetxController {
  static HetHanRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  createHoaDonHetHan(ThemDonHangModel hoadonnhaphang,
      List<Map<String, dynamic>> allThongTinItemXuat) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final xuatHangCollectionRef = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection("XuatHang")
        .doc(hoadonnhaphang.soHD);
    await xuatHangCollectionRef.set(hoadonnhaphang.toJson());
    final newDonXuatHangDocSnapshot = await xuatHangCollectionRef.get();
    final hoaDonCollectionRef =
        newDonXuatHangDocSnapshot.reference.collection("HoaDon");
    for (var itemxuat in allThongTinItemXuat) {
      await hoaDonCollectionRef.add({
        "tensanpham": itemxuat["tensanpham"],
        "soluong": itemxuat["soluong"],
        "gia": itemxuat["gia"],
        "macode": itemxuat["macode"],
        "location": itemxuat["location"],
        "exp": itemxuat["exp"],
      });
    }
  }

  Future<void> deleteExpired(
      List<Map<String, dynamic>> allThongTinItemXuat) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final collectionExpired = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("Expired");
    for (var doc in allThongTinItemXuat) {
      final expValue = doc["exp"].replaceAll('/', '-');
      final queryExp = await collectionExpired
          .doc(expValue)
          .collection("masanpham")
          .doc(doc["macode"])
          .collection("location")
          .doc(doc["location"])
          .get();

      if (queryExp.exists) {
        // Xóa tài liệu hiện tại
        await queryExp.reference.delete();
        final checkLengthlocation = collectionExpired
            .doc(expValue)
            .collection("masanpham")
            .doc(doc["macode"])
            .collection("location");

        final locationDocs = await checkLengthlocation.get();
        if (locationDocs.docs.isEmpty) {
          // Nếu danh sách tài liệu trong collection "location" rỗng, thì xóa "doc["macode"]"
          await collectionExpired
              .doc(expValue)
              .collection("masanpham")
              .doc(doc["macode"])
              .delete();
          final checkLengthMaSanPham =
              collectionExpired.doc(expValue).collection("masanpham");
          final masanphamDocs = await checkLengthMaSanPham.get();
          if (masanphamDocs.docs.isEmpty) {
            await collectionExpired.doc(expValue).delete();
          }
        }
      }
    }
  }

  Future<void> deleteHangHoaExpired(
      List<Map<String, dynamic>> allThongTinItemXuat) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final collectionHangHoaExpired = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("HangHoa");
    for (var doc in allThongTinItemXuat) {
      final expValue = doc["exp"].replaceAll('/', '-');
      final queryExp = await collectionHangHoaExpired
          .doc(doc["macode"])
          .collection("Exp")
          .doc(expValue)
          .collection("location")
          .doc(doc["location"])
          .get();
      if (queryExp.exists) {
        await queryExp.reference.delete();
        final checkLengthlocation = collectionHangHoaExpired
            .doc(doc["macode"])
            .collection("Exp")
            .doc(expValue)
            .collection("location");
        final locationDocs = await checkLengthlocation.get();
        if (locationDocs.docs.isEmpty) {
          // Nếu danh sách tài liệu trong collection "location" rỗng, thì xóa "doc["macode"]"
          await collectionHangHoaExpired
              .doc(doc["macode"])
              .collection("Exp")
              .doc(expValue)
              .delete();
        }
      }
    }
  }

  Future<void> capNhatGiaTriTonKhoHetHan(
      List<Map<String, dynamic>> allThongTinItemNhap) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final collection = FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("HangHoa");

    for (var doc in allThongTinItemNhap) {
      String macode = doc["macode"];
      num soluong = doc["soluong"];

      // Lấy tài liệu từ Firestore
      DocumentSnapshot querySnapshot = await collection.doc(macode).get();

      if (querySnapshot.exists) {
        final existingData = querySnapshot.data() as Map<String, dynamic>;
        // Lấy giá trị tồn kho hiện tại từ Firebase
        num tonkhoHienTai = existingData["tonkho"];

        // Tính giá trị tồn kho mới
        num tonkhoMoi = tonkhoHienTai - soluong;

        // Cập nhật giá trị tonkho
        await collection.doc(macode).update({"tonkho": tonkhoMoi});
      }
    }
  }
}
