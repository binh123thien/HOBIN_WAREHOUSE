import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HetHanController extends GetxController {
  static HetHanController get instance => Get.find();

  final firebaseUser = FirebaseAuth.instance.currentUser;

  Future<List<Map<String, dynamic>>> getFilteredData(
      String startDate, String endDate) async {
    List<Map<String, dynamic>> data = [];

    final CollectionReference expiredCollection = FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser!.uid)
        .collection("Expired");

    QuerySnapshot querySnapshot = await expiredCollection
        .where('exp', isGreaterThanOrEqualTo: startDate)
        .where('exp', isLessThanOrEqualTo: endDate)
        .get();

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      QuerySnapshot locationSnapshot =
          await docSnapshot.reference.collection('masanpham').get();

      for (QueryDocumentSnapshot locationDocSnapshot in locationSnapshot.docs) {
        QuerySnapshot subCollectionSnapshot =
            await locationDocSnapshot.reference.collection('location').get();

        for (QueryDocumentSnapshot subDocSnapshot
            in subCollectionSnapshot.docs) {
          Map<String, dynamic>? locationData =
              subDocSnapshot.data() as Map<String, dynamic>?;
          if (locationData != null) {
            data.add(locationData);
          }
        }
      }
    }
    print(data);
    return data;
  }
}
