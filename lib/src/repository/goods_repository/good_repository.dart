import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/features/dashboard/models/danhmuc_model.dart';
import 'package:hobin_warehouse/src/utils/image_picker/image_picker.dart';

import '../../features/dashboard/controllers/goods/chondanhmuc_controller.dart';
import '../../features/dashboard/controllers/goods/them_hanghoa_controller.dart';
import '../../features/dashboard/models/add/add_location_model(canK).dart';
import '../../features/dashboard/models/donvi_model.dart';
import '../../features/dashboard/models/themhanghoa_model.dart';

class GoodRepository extends GetxController {
  static GoodRepository get instance => Get.find();
  List<Map<String, dynamic>> listLocationHangHoaSi = [];
  List<Map<String, dynamic>> listLocationHangHoaLePicked = [];
  RxBool expandShowMore = false.obs;
  RxList<Map<String, dynamic>> listNhapXuathang = <Map<String, dynamic>>[].obs;
  final _db = FirebaseFirestore.instance;

//=============================== Thêm hàng hóa mới =============================================
  // Lưu trữ good trên firestore
  createCollectionFirestore(
      HangHoaModel hanghoa, String macode, String tensanpham) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    //lấy giá trị trả về của hàm checkHangHoa
    final snapshot = await checkHangHoa(tensanpham);
    if (snapshot.docs.isNotEmpty) {
      Get.snackbar("Thất bại", "Sản phẩm đã có", colorText: Colors.black);
    } else {
      await _db
          .collection("Users")
          .doc(firebaseUser!.uid)
          .collection("Goods")
          .doc(firebaseUser.uid)
          .collection("HangHoa")
          .doc(macode)
          .set(hanghoa.toJson())
          .whenComplete(() => Get.snackbar(
              "Thành công", "Đã thêm hàng vào danh sách",
              colorText: Colors.green));
    }
  }

  checkHangHoa(String tensanpham) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    QuerySnapshot snapshot = await _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("HangHoa")
        .where('tensanpham', isEqualTo: tensanpham)
        .get();
    return snapshot;
  }

//=============================== End thêm hàng hóa mới =======================================
//================================ update hang hoa ==================
  Future<dynamic> updateGood(String docGoodID, String photoGoodUpdate,
      String tensanpham, Uint8List? imageChanged) async {
    final controllerThemHangHoa = Get.put(ThemHangHoaController());
    final controllerDanhMuc = Get.put(ChonDanhMucController());

    final firebaseUser = FirebaseAuth.instance.currentUser;
    //lấy giá trị trả về của hàm checkHangHoa
    final snapshot = await checkHangHoa(tensanpham);
    bool duplicateName = false; // Biến flag để ktra hàng đã có hay chưa
    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        // doc.id != docID: nhập trùng tên thằng đã tồn tại (hiểu ngược là lụm TH ==)
        if (doc.id != docGoodID && doc["tensanpham"] == tensanpham) {
          duplicateName = true;
          break;
        }
      }
    }

    if (duplicateName) {
      Get.snackbar("Thất bại", "Sản phẩm đã có", colorText: Colors.black);
    } else {
      //update URL và các trường khác trên FireStore
      await _db
          .collection("Users")
          .doc(firebaseUser!.uid)
          .collection("Goods")
          .doc(firebaseUser.uid)
          .collection("HangHoa")
          .doc(docGoodID)
          .update({
        'tensanpham': controllerThemHangHoa.tenSanPhamController.text.trim(),
        'gianhap': double.tryParse(controllerThemHangHoa.gianhapController.text
                .replaceAll(",", "")) ??
            0,
        'giaban': double.tryParse(controllerThemHangHoa.giabanController.text
                .replaceAll(",", "")) ??
            0,
        'phanloai': controllerThemHangHoa.phanloaiController.text,
        'donvi': controllerThemHangHoa.donviController.text,
        'danhmuc': controllerDanhMuc.selectedDanhMuc,
        'photoGood': photoGoodUpdate
      }).then((_) async {
        if (imageChanged != null) {
          await StoreData().saveImageGood(
              file: imageChanged,
              user: firebaseUser.uid,
              macodeGood: docGoodID);
        }
      });
    }
    //lấy doc mới cập nhật return về (get dữ liệu về trang trước)
    final updatedDoc = await _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("HangHoa")
        .doc(docGoodID)
        .get();
    return updatedDoc.data();
  }

//============================== end update hang hoa =====================
  createDonViFirestore(DonViModel donvi) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    await _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("DonVi")
        .add(donvi.toJson())
        .whenComplete(() => Get.snackbar(
            "Thành công", "Đã thêm đơn vị mới vào danh sách",
            colorText: Colors.green));
  }

  createDanhMucFirestore(DanhMucModel danhmuc) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    await _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("DanhMuc")
        .add(danhmuc.toJson())
        .whenComplete(() => Get.snackbar(
            "Thành công", "Đã thêm danh mục mới vào danh sách",
            colorText: Colors.green));
  }

  gethanghoa(String phanloai) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final gethanghoa = FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("HangHoa")
        .where("phanloai", isEqualTo: phanloai)
        .snapshots();
    return gethanghoa;
  }

  getAllhanghoa() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final getAllhanghoa = FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("HangHoa")
        .snapshots();
    return getAllhanghoa;
  }

//====================2 hàm get All dưới khác so với hàm getAllhanghoa (getALL theo collection)=============
  getAlldonvi() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final getAlldonvi = FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("DonVi")
        .snapshots();
    return getAlldonvi;
  }

  getAlldanhmuc() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final getAlldanhmuc = FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("DanhMuc")
        .snapshots();
    return getAlldanhmuc;
  }

//============================== end 2 hàm GetAll theo field ========================
  sortby(List<dynamic> allItems, String controller) {
    if (controller == "Giá tăng dần") {
      allItems.sort((a, b) => a["giaban"].compareTo(b["giaban"]));
      return allItems;
    } else if (controller == "Giá giảm dần") {
      allItems.sort((b, a) => a["giaban"].compareTo(b["giaban"]));
      print(allItems);
      return allItems;
    } else if (controller == "Tồn kho tăng dần") {
      allItems.sort((a, b) => a["tonkho"].compareTo(b["tonkho"]));
      return allItems;
    } else if (controller == "Tồn kho giảm dần") {
      allItems.sort((b, a) => a["tonkho"].compareTo(b["tonkho"]));
      return allItems;
    } else if (controller == "Đã bán tăng dần") {
      allItems.sort((a, b) => a["daban"].compareTo(b["daban"]));
      return allItems;
    } else if (controller == "Đã bán giảm dần") {
      allItems.sort((b, a) => a["daban"].compareTo(b["daban"]));
      return allItems;
    } else if (controller == "A => Z") {
      allItems.sort((a, b) => a["tensanpham"].compareTo(b["tensanpham"]));
      return allItems;
    } else if (controller == "Z => A") {
      allItems.sort((b, a) => a["tensanpham"].compareTo(b["tensanpham"]));
      return allItems;
    }
  }

  //================================= chi tiết hàng hóa =============================================================
//========================== Tìm UID theo tên sau đó Delete theo UID ===============================================
// Tìm DonVi đã chọn theo tên để tìm được UID
  Future<void> deleteHangHoaByTen(String tenHangHoaDelete) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final QuerySnapshot snapshot = await _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("HangHoa")
        .where("tensanpham", isEqualTo: tenHangHoaDelete)
        .get();
    //Get được Donvi theo ten donvi
    final List<QueryDocumentSnapshot> docs = snapshot.docs;
    if (docs.isNotEmpty) {
      final String hangHoaID = docs.first.id;
      await deleteHangHoa(hangHoaID);
    } else {
      print("Không tìm thấy hàng hóa với tên tương ứng.");
    }
  }

  deleteHangHoa(String docDelete) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    await _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("HangHoa")
        .doc(docDelete)
        .delete()
        .whenComplete(() {
      Get.snackbar("Xóa thành công", "Hàng hóa đã được xóa khỏi danh sách",
          colorText: Colors.green);
    });
    // where("donvi", isEqualTo: donViDelete).
  }

  createLocaion(
      AddLocationModel locationModel, String macode, String id) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    await _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("HangHoa")
        .doc(macode)
        .collection("Location")
        .doc(id)
        .set(locationModel.toJson())
        .whenComplete(() => Get.snackbar(
            "Thành công", "Đã thêm hàng vào danh sách",
            colorText: Colors.green));
  }

  getAllLocation(String macode) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final getAllLocation = FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("HangHoa")
        .doc(macode)
        .collection("Location")
        .snapshots();
    return getAllLocation;
  }

  Future<List<Map<String, dynamic>>> getLocationData(String macode) async {
    List<Map<String, dynamic>> locationList = [];
    final firebaseUser = FirebaseAuth.instance.currentUser;
    try {
      // Truy cập vào collection "Exp" có sẵn từ collection "Users"
      QuerySnapshot expSnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(firebaseUser!.uid)
          .collection("Goods")
          .doc(firebaseUser.uid)
          .collection("HangHoa")
          .doc(macode)
          .collection("Exp")
          .get();

      // Duyệt qua các tài liệu trong collection "Exp"
      for (QueryDocumentSnapshot expDoc in expSnapshot.docs) {
        // Truy cập vào collection "location" cho từng tài liệu "Exp"
        QuerySnapshot locationSnapshot = await FirebaseFirestore.instance
            .collection("Users")
            .doc(firebaseUser.uid)
            .collection("Goods")
            .doc(firebaseUser.uid)
            .collection("HangHoa")
            .doc(macode)
            .collection("Exp")
            .doc(expDoc.id)
            .collection("location")
            .get();

        // Duyệt qua các tài liệu trong collection "location"
        for (QueryDocumentSnapshot locationDoc in locationSnapshot.docs) {
          // Lấy dữ liệu của từng tài liệu và thêm vào danh sách
          Map<String, dynamic> locationData =
              locationDoc.data() as Map<String, dynamic>;
          locationList.add(locationData);
        }
      }
    } catch (e) {
      print("Lỗi khi truy cập cơ sở dữ liệu: $e");
    }

    return locationList;
  }
}
