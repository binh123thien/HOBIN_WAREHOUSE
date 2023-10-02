import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class XuatHangRepository extends GetxController {
  Future<List<Map<String, dynamic>>> createListLocation(
      Map<String, dynamic> thongTinItemXuat, num maxQuantity) async {
    bool breakvonglaplon = false;
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final collection = await FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("HangHoa")
        .doc(thongTinItemXuat["macode"])
        .collection("Exp")
        .get();

    final dateFormatter = DateFormat("dd-MM-yyyy");
    final sortedDocs =
        collection.docs.toList(); // Convert to List<QueryDocumentSnapshot>

    sortedDocs.sort((a, b) {
      final aExpDate = dateFormatter.parseStrict(a.data()["exp"]);
      final bExpDate = dateFormatter.parseStrict(b.data()["exp"]);
      return aExpDate.compareTo(bExpDate);
    });
    final List<Map<String, dynamic>> result = [];
    for (var doc in sortedDocs) {
      if (!breakvonglaplon) {
        final locationCollection = FirebaseFirestore.instance
            .collection("Users")
            .doc(firebaseUser.uid)
            .collection("Goods")
            .doc(firebaseUser.uid)
            .collection("HangHoa")
            .doc(thongTinItemXuat["macode"])
            .collection("Exp")
            .doc(doc.id)
            .collection("location");
        final locationData = await locationCollection.get();
        for (var locationDoc in locationData.docs) {
          final soluong =
              num.tryParse(locationDoc.data()["soluong"].toString()) ?? 0;
          if (maxQuantity <= soluong) {
            // Nếu biến truyền vào lớn hơn hoặc bằng soluong, thêm vào danh sách
            result.add({
              "location": locationDoc["location"],
              "soluong": maxQuantity,
              "exp": locationDoc["exp"]
            });
            breakvonglaplon = true;
            break; // Dừng vòng lặp
          } else {
            // Nếu biến truyền vào nhỏ hơn soluong
            result.add({
              "location": locationDoc["location"],
              "soluong": soluong,
              "exp": locationDoc["exp"]
            });
            maxQuantity -= soluong; // Trừ đi soluong
          }
        }
      }
    }
    return result;
  }
}
