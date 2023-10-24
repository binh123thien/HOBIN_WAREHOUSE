import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HetHanHistoryRepository extends GetxController {
  static HetHanHistoryRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  Future<void> updateTrangThaiHuy(String billType, String soHD) async {
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

  Future<void> createHuyDonExpired(List<dynamic> dataList) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    DateFormat inputFormat = DateFormat("dd-MM-yyyy");
    DateFormat outputFormat = DateFormat("yyyy-MM-dd");
    final collection = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("Expired");
    for (final data in dataList) {
      for (var locationAndexp in data["locationAndexp"]) {
        final expValue = locationAndexp["exp"].replaceAll('/', '-');
        // Chuyển đổi chuỗi thành đối tượng DateTime
        DateTime date = inputFormat.parse(expValue);
        // Chuyển đổi đối tượng DateTime thành chuỗi mới
        String expNew = outputFormat.format(date);
        // Kiểm tra xem có tài liệu trên Firestore có trường 'exp' tương tự không
        final queryExp = await collection.where("exp", isEqualTo: expNew).get();
        if (queryExp.docs.isEmpty) {
          await collection.doc(expValue).set({"exp": expNew});
        }
        final queryMacode = await collection
            .doc(expValue)
            .collection("masanpham")
            .where("macode", isEqualTo: data["macode"])
            .get();
        if (queryMacode.docs.isEmpty) {
          await collection
              .doc(expValue)
              .collection("masanpham")
              .doc(data["macode"])
              .set({"macode": data["macode"]});
        }

        final checkData = await collection
            .doc(expValue)
            .collection("masanpham")
            .doc(data["macode"])
            .collection("location")
            .doc(locationAndexp["location"])
            .get();

        final dataToUpdate = {
          "exp": locationAndexp["exp"],
          "gia": data["gia"],
          "location": locationAndexp["location"],
          "tensanpham": data["tensanpham"],
          "soluong": locationAndexp["soluong"],
          "macode": data["macode"],
        };

        if (checkData.exists) {
          // Nếu tài liệu đã tồn tại, tăng giá trị của trường "soluong"
          final existingData = checkData.data() as Map<String, dynamic>;
          final existingSoluong = existingData["soluong"] ?? 0;
          final additionalSoluong = locationAndexp["soluong"] ?? 0;
          dataToUpdate["soluong"] = existingSoluong + additionalSoluong;
        }
        // Sử dụng `set` hoặc `update` để cập nhật dữ liệu
        await collection
            .doc(expValue)
            .collection("masanpham")
            .doc(data["macode"]!)
            .collection("location")
            .doc(locationAndexp["location"])
            .set(dataToUpdate);
      }
    }
  }
}
