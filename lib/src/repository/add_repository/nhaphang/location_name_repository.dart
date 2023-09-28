import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LocationNameRepo extends GetxController {
  static LocationNameRepo get instance => Get.find();
  getAllLocationName() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final getAllLocationName = FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("LocationName")
        .snapshots();
    return getAllLocationName;
  }
}
