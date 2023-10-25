import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/snackbar/toast.dart';
import 'package:intl/intl.dart';

import '../../../features/dashboard/models/themdonhang_model.dart';
import '../../history_repository/hethan_history_repository.dart';
import '../xuathang/xuathang_repository.dart';

class NhapHangRepository extends GetxController {
  final _db = FirebaseFirestore.instance;
  final controllerXuatHangRepo = Get.put(XuatHangRepository());
  final controllerHetHanHistoryRepo = Get.put(HetHanHistoryRepository());

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

  Future<void> createExpired(List<dynamic> dataList) async {
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
        "soluong": data["soluong"],
        "macode": data["macode"],
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

  Future<void> createHangHoaExpired(List<dynamic> allThongTinItemNhap) async {
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
      List<dynamic> allThongTinItemNhap) async {
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

  //======================Huy Don=========================
//tra hang lai kho
  Future<String> xuatkhoNhapHangHangHoaExpired(
      List<dynamic> allThongTinItemNhap, String soHD, String billType) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    bool checkError = false;
    final collection = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("HangHoa");
    for (var doc in allThongTinItemNhap) {
      final expValue = doc["exp"].replaceAll('/', '-');
      final checkLocation = await collection
          .doc(doc["macode"])
          .collection("Exp")
          .doc(expValue)
          .collection("location")
          .where("location", isEqualTo: doc["location"])
          .get();
      if (checkLocation.docs.isEmpty) {
        ToastWidget.showToast("Lỗi! Sản phẩm không còn trong kho!");
        checkError = true;
        break;
      } else //neu trong kho không đủ số
      if (checkLocation.docs.first.data()["soluong"] < doc["soluong"]) {
        ToastWidget.showToast("Lỗi! Sản phẩm trong kho không đủ để xuất!");
        checkError = true;
        break;
      } else //neu trong kho bằng với đơn hàng cần hủy thì delete
      if (checkLocation.docs.first.data()["soluong"] == doc["soluong"]) {
        // Xóa tài liệu hiện tại
        await collection
            .doc(doc["macode"])
            .collection("Exp")
            .doc(expValue)
            .collection("location")
            .doc(checkLocation.docs.first.id)
            .delete()
            .then((_) async {
          //check length doc Exp, leng empty thi xoa doc Exp
          final checkExpLength =
              collection.doc(doc["macode"]).collection("Exp");
          final expDocs = await checkExpLength.get();
          if (expDocs.docs.isEmpty) {
            // Nếu danh sách tài liệu trong collection "location" rỗng, thì xóa "doc["macode"]"
            await checkExpLength
                .doc(doc["macode"])
                .collection("Exp")
                .doc(expValue)
                .delete();
          }
        }).then((_) {
          handleXuatKhoNhapHang(allThongTinItemNhap, soHD, billType).then((_) {
            ToastWidget.showToast("Hủy đơn thành công!");
          });
        });
      } else {
        // Nếu dữ liệu đã tồn tại, thực hiện giảm giá trị "soluong"
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final existingDoc = checkLocation.docs.first;
          final existingSoluong = existingDoc.data()["soluong"];
          final newSoluong = existingSoluong - doc["soluong"];
          // Cập nhật giá trị mới của "soluong" trong tài liệu
          transaction.update(existingDoc.reference, {"soluong": newSoluong});
        }).then((_) {
          handleXuatKhoNhapHang(allThongTinItemNhap, soHD, billType).then((_) {
            ToastWidget.showToast("Hủy đơn thành công!");
          });
        });
      }
    }
    return checkError ? "Error" : "Success";
  }

  Future<void> handleXuatKhoNhapHang(
      List<dynamic> allThongTinItemNhap, String soHD, String billType) async {
    //giảm giá trị tồn kho
    await controllerXuatHangRepo
        .capNhatGiaTriTonKhoXuatHang(allThongTinItemNhap);
    //cap nhat trang thai don hang
    await controllerHetHanHistoryRepo.updateTrangThaiHuy(billType, soHD);
    await controllerXuatHangRepo
        .updateExpiredXuatKhoNhapHang(allThongTinItemNhap);
  }

  Future<void> nhapkhoXuatHangHangHoaExpired(
      List<dynamic> allThongTinItemNhap, String soHD, String billType) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final collection = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("HangHoa");
    for (var doc in allThongTinItemNhap) {
      for (var locationAndexp in doc["locationAndexp"]) {
        final expValue = locationAndexp["exp"].replaceAll('/', '-');
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
            .where("location", isEqualTo: locationAndexp["location"])
            .get();
        if (checkData.docs.isEmpty) {
          await collection
              .doc(doc["macode"])
              .collection("Exp")
              .doc(expValue)
              .collection("location")
              .doc(locationAndexp["location"])
              .set({
            "exp": locationAndexp["exp"],
            "location": locationAndexp["location"],
            "soluong": locationAndexp["soluong"]
          });
        } else {
          // Nếu dữ liệu đã tồn tại, thực hiện tăng giá trị "soluong"
          await FirebaseFirestore.instance.runTransaction((transaction) async {
            final existingDoc = checkData.docs.first;
            final existingSoluong = existingDoc.data()["soluong"];
            final newSoluong = existingSoluong + locationAndexp["soluong"];

            // Cập nhật giá trị mới của "soluong" trong tài liệu
            transaction.update(existingDoc.reference, {"soluong": newSoluong});
          });
        }
      }
    }
  }
}
