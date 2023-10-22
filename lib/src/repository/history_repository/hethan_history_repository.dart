import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HetHanHistoryRepository extends GetxController {
  static HetHanHistoryRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  updateTrangThaiHuy(String billType, String soHD) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final docRef = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection(billType == "NhapHang" ? "NhapHang" : "XuatHang")
        .doc(soHD);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      await docRef.set({
        "trangthai": "Hủy",
      }, SetOptions(merge: true));
    }
  }
}
