import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../features/dashboard/models/statistics/lichsutrano_model.dart';

class LichSuTraNoRepository extends GetxController {
  static LichSuTraNoRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  createLichSuTraNo(LichSuTraNoModel lichsutrano, String soHD) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    await _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection("LichSuTraNo")
        .doc(soHD)
        .set(lichsutrano.toJson());
  }
}
