import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DoanhThuController extends GetxController {
  static DoanhThuController get instance => Get.find();
  var doanhThu = <Map<String, dynamic>>[].obs;
  var doanhThuTheoTuan = <Map<String, dynamic>>[].obs;

  Future<void> loadDoanhThu() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    DateTime now = DateTime.now();
    List<DateTime> dateList = [];
    for (int i = 0; i < 35; i++) {
      dateList.add(now.subtract(Duration(days: i)));
    }
    List<Map<String, dynamic>> tempDoanhThu = [];
    for (DateTime date in dateList) {
      String dateString = DateFormat('dd/MM/yyyy').format(date);
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(firebaseUser!.uid)
          .collection("History")
          .doc(firebaseUser.uid)
          .collection('BanHang')
          .where('datetime', isEqualTo: dateString)
          .get();
      num total =
          snapshot.docs.fold(0, (prev, doc) => prev + doc['tongthanhtoan']);

      // Tính tổng số doc trong datetime của ngày đó có trường "trangthai"="thanhcong"
      int tongThanhCong =
          snapshot.docs.where((doc) => doc['trangthai'] == 'Thành công').length;
      int tongDangCho =
          snapshot.docs.where((doc) => doc['trangthai'] == 'Đang chờ').length;
      int tongHuy =
          snapshot.docs.where((doc) => doc['trangthai'] == 'Hủy').length;
      // Thêm cặp key-value mới vào list tempDoanhThu
      Map<String, dynamic> newEntry = {
        dateString: total,
        'thanhcong': tongThanhCong,
        "dangcho": tongDangCho,
        "huy": tongHuy,
      };
      tempDoanhThu.add(newEntry);
    }
    doanhThu.value = tempDoanhThu;
    print(doanhThu);

    // Tạo danh sách các tuần cần tính toán
    List<List<DateTime>> weeksList = [];
    for (int i = 0; i < 5; i++) {
      DateTime endOfWeek = DateTime.now().subtract(Duration(days: i * 7));
      DateTime startOfWeek =
          endOfWeek.subtract(Duration(days: endOfWeek.weekday - 1));
      List<DateTime> weekDays = [];
      for (int j = 0; j < 7; j++) {
        DateTime day = startOfWeek.add(Duration(days: j));
        weekDays.add(day);
      }
      weeksList.add(weekDays);
    }

// Duyệt qua danh sách các tuần để tính tổng
    List<Map<String, dynamic>> tempDoanhThuTheoTuan = [];
    for (List<DateTime> week in weeksList) {
      String startWeekString = DateFormat('dd/MM').format(week.first);
      String endWeekString = DateFormat('dd/MM').format(week.last);

      num total = 0;
      num tongThanhCong = 0;
      num tongDangCho = 0;
      num tongHuy = 0;
      for (DateTime date in week) {
        String dateString = DateFormat('dd/MM/yyyy').format(date);
        Map<String, dynamic>? entry = doanhThu
            .firstWhereOrNull((element) => element.containsKey(dateString));
        if (entry != null) {
          total += entry[dateString];
          tongThanhCong += entry['thanhcong'];
          tongDangCho += entry['dangcho'];
          tongHuy += entry['huy'];
        }
      }

      // Thêm cặp key-value mới vào list doanhThuTheoTuan
      Map<String, dynamic> newEntry = {
        '$startWeekString - $endWeekString': total,
        'thanhcong': tongThanhCong,
        "dangcho": tongDangCho,
        "huy": tongHuy,
      };

      tempDoanhThuTheoTuan.add(newEntry);
      doanhThuTheoTuan.value = tempDoanhThuTheoTuan;
    }

// In kết quả tính toán ra màn hình
    print(doanhThuTheoTuan);
  }
}
