import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

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
}
