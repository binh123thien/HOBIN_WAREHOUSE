import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../features/dashboard/models/themdonhang_model.dart';

class XuatHangRepository extends GetxController {
  final _db = FirebaseFirestore.instance;
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

// ====================================== Them đơn xuất hàng ==================//
  createHoaDonXuatHang(ThemDonHangModel hoadonxuathang,
      List<Map<String, dynamic>> allThongTinItemXuat) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final xuatHangCollectionRef = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection("XuatHang")
        .doc(hoadonxuathang.soHD);
    await xuatHangCollectionRef.set(hoadonxuathang.toJson());
    final newDonXuatHangDocSnapshot = await xuatHangCollectionRef.get();
    final hoaDonCollectionRef =
        newDonXuatHangDocSnapshot.reference.collection("HoaDon");
    for (var itemxuat in allThongTinItemXuat) {
      await hoaDonCollectionRef.add({
        "tensanpham": itemxuat["tensanpham"],
        "soluong": itemxuat["soluong"],
        "gia": itemxuat["gia"],
        "macode": itemxuat["macode"],
        "locationAndexp": itemxuat["locationAndexp"],
      });
    }
  }

  Future<void> updateExpired(
      List<Map<String, dynamic>> allThongTinItemXuat) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final collectionExpired = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("Expired");
    for (var doc in allThongTinItemXuat) {
      final listLocation = doc["locationAndexp"];
      for (var location in listLocation) {
        final expValue = location["exp"].replaceAll('/', '-');
        final queryExp = await collectionExpired
            .doc(expValue)
            .collection("masanpham")
            .doc(doc["macode"])
            .collection("location")
            .doc(location["location"])
            .get();

        if (queryExp.exists) {
          // Lấy dữ liệu từ tài liệu hiện tại
          final existingData = queryExp.data() as Map<String, dynamic>;
          final soLuongFirebase = existingData["soluong"] ?? 0;
          final soluongtronglist = location["soluong"] ?? 0;

          if (soLuongFirebase == soluongtronglist) {
            // Xóa tài liệu hiện tại
            await queryExp.reference.delete();
          } else if (soLuongFirebase > soluongtronglist) {
            // Cập nhật trường "soluong" của tài liệu hiện tại
            await queryExp.reference
                .update({"soluong": soLuongFirebase - soluongtronglist});
          }
        }
      }
    }
  }

  Future<void> updateHangHoaExpired(
      List<Map<String, dynamic>> allThongTinItemXuat) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final collectionHangHoaExpired = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("HangHoa");
    for (var doc in allThongTinItemXuat) {
      final listLocation = doc["locationAndexp"];
      for (var location in listLocation) {
        final expValue = location["exp"].replaceAll('/', '-');
        final queryExp = await collectionHangHoaExpired
            .doc(doc["macode"])
            .collection("Exp")
            .doc(expValue)
            .collection("location")
            .doc(location["location"])
            .get();
        if (queryExp.exists) {
          // Lấy dữ liệu từ tài liệu hiện tại
          final existingData = queryExp.data() as Map<String, dynamic>;
          final soLuongFirebase = existingData["soluong"] ?? 0;
          final soluongtronglist = location["soluong"] ?? 0;

          if (soLuongFirebase == soluongtronglist) {
            // Xóa tài liệu hiện tại
            await queryExp.reference.delete();
          } else if (soLuongFirebase > soluongtronglist) {
            // Cập nhật trường "soluong" của tài liệu hiện tại
            await queryExp.reference
                .update({"soluong": soLuongFirebase - soluongtronglist});
          }
        }
      }
    }
  }

  Future<void> capNhatGiaTriTonKhoXuatHang(
      List<Map<String, dynamic>> allThongTinItemNhap) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final collection = FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("HangHoa");

    for (var doc in allThongTinItemNhap) {
      String macode = doc["macode"];
      num soluong = doc["soluong"];

      // Lấy tài liệu từ Firestore
      DocumentSnapshot querySnapshot = await collection.doc(macode).get();

      if (querySnapshot.exists) {
        final existingData = querySnapshot.data() as Map<String, dynamic>;
        // Lấy giá trị tồn kho hiện tại từ Firebase
        num tonkhoHienTai = existingData["tonkho"];

        // Tính giá trị tồn kho mới
        num tonkhoMoi = tonkhoHienTai - soluong;

        // Cập nhật giá trị tonkho
        await collection.doc(macode).update({"tonkho": tonkhoMoi});
      }
    }
  }

//========================== Tinh Doanh Thu ===================================//
  String getTuanFromDate(String ngay, String field) {
    final dateFormat = DateFormat("dd-MM-yyyy");
    final date = dateFormat.parse(ngay);

    // Tạo ra một DateTime của ngày đầu tiên của năm
    final startOfYear = DateTime(date.year, 1, 1);

    // Tính toán số ngày kể từ ngày đầu tiên của năm đến ngày cho trước
    final daysSinceStartOfYear = date.difference(startOfYear).inDays;

    // Tính toán tuần dựa trên số ngày đã trôi qua và tuần đầu tiên của năm
    final weekNumber = (daysSinceStartOfYear / 7).ceil();
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final tuanNgay =
        'Tuần $weekNumber (${dateFormat.format(startOfWeek).replaceAll("-", "Th").substring(0, 6)} - ${dateFormat.format(endOfWeek).replaceAll("-", "Th").substring(0, 6)})';
    final formattedWeek = DateFormat("yyyy-$weekNumber").format(date);
    final week =
        "$formattedWeek (${dateFormat.format(startOfWeek)} ${dateFormat.format(endOfWeek)})";
    final formatday = DateFormat("yyyy-MM-dd").format(date);
    final formatyear = DateFormat("yyyy-MM").format(date);
    if (field == "datetime") {
      return tuanNgay;
    } else if (field == "week") {
      return week;
    } else if (field == "day") {
      return formatday;
    } else {
      return formatyear;
    }
  }

  Future<void> createTongDoanhThuNgay(String ngay, num doanhthu, num no) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final docRef = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection("TongDoanhThu")
        .doc(firebaseUser.uid)
        .collection("HangNgay")
        .doc(ngay);

    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Nếu tài liệu đã tồn tại, cộng trường doanhthu lại
      final existingDoanhThu = docSnapshot.data()?['doanhthu'] ?? 0;
      final newDoanhThu = existingDoanhThu + doanhthu;

      await docRef.update({'doanhthu': newDoanhThu});

      if (no == 0) {
        await docRef.update({'thanhcong': FieldValue.increment(1)});
      } else if (no > 0) {
        await docRef.update({'dangcho': FieldValue.increment(1)});
      }
    } else {
      // Nếu tài liệu chưa tồn tại, tạo mới tài liệu với trường doanhthu và các trường khác
      await docRef.set({
        'datetime': ngay,
        'doanhthu': doanhthu,
        'thanhcong': no == 0 ? 1 : 0,
        'dangcho': no > 0 ? 1 : 0,
        'huy': 0,
        'day': getTuanFromDate(ngay, "day"),
      });
    }
  }

  Future<void> createTongDoanhThuTuan(String ngay, num doanhthu, num no) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final docRef = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection("TongDoanhThu")
        .doc(firebaseUser.uid)
        .collection("HangTuan");

    final tuanNgay = getTuanFromDate(ngay, "datetime");

    final docSnapshot = await docRef.doc(tuanNgay).get();

    if (docSnapshot.exists) {
      // Nếu tài liệu đã tồn tại, cộng trường doanhthu lại
      final existingDoanhThu = docSnapshot.data()?['doanhthu'] ?? 0;
      final newDoanhThu = existingDoanhThu + doanhthu;

      await docRef.doc(tuanNgay).update({'doanhthu': newDoanhThu});

      if (no == 0) {
        await docRef
            .doc(tuanNgay)
            .update({'thanhcong': FieldValue.increment(1)});
      } else if (no > 0) {
        await docRef.doc(tuanNgay).update({'dangcho': FieldValue.increment(1)});
      }
    } else {
      // Nếu tài liệu chưa tồn tại, tạo mới tài liệu với trường doanhthu và các trường khác
      await docRef.doc(tuanNgay).set({
        'datetime': tuanNgay,
        'doanhthu': doanhthu,
        'thanhcong': no == 0 ? 1 : 0,
        'dangcho': no > 0 ? 1 : 0,
        'huy': 0,
        'week': getTuanFromDate(ngay, "week"),
      });
    }
  }

  Future<void> createTongDoanhThuThang(
      String ngay, num doanhthu, num no) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final dateFormat = DateFormat("dd-MM-yyyy");
    final date = dateFormat.parse(ngay);

    // Tạo ra định dạng chuỗi "Tháng MM-yyyy" từ ngày cho trước
    final monthFormat = DateFormat("'Tháng' MM-yyyy");
    final monthString = monthFormat.format(date);

    final docRef = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection("TongDoanhThu")
        .doc(firebaseUser.uid)
        .collection("HangThang")
        .doc(monthString);

    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Nếu tài liệu đã tồn tại, cộng trường doanhthu lại
      final existingDoanhThu = docSnapshot.data()?['doanhthu'] ?? 0;
      final newDoanhThu = existingDoanhThu + doanhthu;

      await docRef.update({'doanhthu': newDoanhThu});

      if (no == 0) {
        await docRef.update({'thanhcong': FieldValue.increment(1)});
      } else if (no > 0) {
        await docRef.update({'dangcho': FieldValue.increment(1)});
      }
    } else {
      // Nếu tài liệu chưa tồn tại, tạo mới tài liệu với trường doanhthu và các trường khác
      await docRef.set({
        'datetime': monthString,
        'doanhthu': doanhthu,
        'thanhcong': no == 0 ? 1 : 0,
        'dangcho': no > 0 ? 1 : 0,
        'huy': 0,
        'month': getTuanFromDate(ngay, "month"),
      });
    }
  }
}
