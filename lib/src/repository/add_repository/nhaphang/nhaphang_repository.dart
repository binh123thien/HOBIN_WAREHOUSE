import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../features/dashboard/models/themdonhang_model.dart';

class NhapHangRepository extends GetxController {
  final _db = FirebaseFirestore.instance;

  createHoaDonNhapHang(ThemDonHangModel hoadonnhaphang,
      List<Map<String, dynamic>> allThongTinItemXuat) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final xuatHangCollectionRef = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection("NhapHang")
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

  Future<void> createExpired(List<Map<String, dynamic>> dataList) async {
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
      final expValue = data["exp"].replaceAll('/', '-');
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
          .doc(data["location"])
          .get();

      final dataToUpdate = {
        "exp": data["exp"],
        "gia": data["gia"],
        "location": data["location"],
        "tensanpham": data["tensanpham"],
        "soluong": data["soluong"]
      };

      if (checkData.exists) {
        // Nếu tài liệu đã tồn tại, tăng giá trị của trường "soluong"
        final existingData = checkData.data() as Map<String, dynamic>;
        final existingSoluong = existingData["soluong"] ?? 0;
        final additionalSoluong = data["soluong"] ?? 0;
        dataToUpdate["soluong"] = existingSoluong + additionalSoluong;
      }

// Sử dụng `set` hoặc `update` để cập nhật dữ liệu
      await collection
          .doc(expValue)
          .collection("masanpham")
          .doc(data["macode"]!)
          .collection("location")
          .doc(data["location"])
          .set(dataToUpdate);
    }
  }

  Future<void> createHangHoaExpired(
      List<Map<String, dynamic>> allThongTinItemNhap) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final collection = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("HangHoa");
    for (var doc in allThongTinItemNhap) {
      final expValue = doc["exp"].replaceAll('/', '-');
      final queryExp = await collection
          .doc(doc["macode"])
          .collection("Exp")
          .where("exp", isEqualTo: expValue)
          .get();
      if (queryExp.docs.isEmpty) {
        await collection
            .doc(doc["macode"])
            .collection("Exp")
            .doc(expValue)
            .set({"exp": expValue});
      }
      final checkData = await collection
          .doc(doc["macode"])
          .collection("Exp")
          .doc(expValue)
          .collection("location")
          .where("location", isEqualTo: doc["location"])
          .get();
      if (checkData.docs.isEmpty) {
        await collection
            .doc(doc["macode"])
            .collection("Exp")
            .doc(expValue)
            .collection("location")
            .doc(doc["location"])
            .set({
          "exp": doc["exp"],
          "location": doc["location"],
          "soluong": doc["soluong"]
        });
      } else {
        // Nếu dữ liệu đã tồn tại, thực hiện tăng giá trị "soluong"
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final existingDoc = checkData.docs.first;
          final existingSoluong = existingDoc.data()["soluong"];
          final newSoluong = existingSoluong + doc["soluong"];

          // Cập nhật giá trị mới của "soluong" trong tài liệu
          transaction.update(existingDoc.reference, {"soluong": newSoluong});
        });
      }
    }
  }

  Future<void> capNhatGiaTriTonKhoNhapHang(
      List<Map<String, dynamic>> allThongTinItemNhap) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final collection = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("HangHoa");
    for (var doc in allThongTinItemNhap) {
      String macode = doc["macode"];
      int soluong = doc["soluong"];
      QuerySnapshot querySnapshot =
          await collection.where("macode", isEqualTo: macode).get();
      if (querySnapshot.docs.isNotEmpty) {
        // Lấy tài liệu duy nhất có macode trùng
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;

        // Lấy giá trị tồn kho hiện tại từ Firebase
        num tonkhoHienTai = docSnapshot["tonkho"];

        // Tính giá trị tồn kho mới
        num tonkhoMoi = tonkhoHienTai + soluong;

        // Cập nhật giá trị tonkho
        await collection.doc(docSnapshot.id).update({"tonkho": tonkhoMoi});
      }
    }
  }
}
