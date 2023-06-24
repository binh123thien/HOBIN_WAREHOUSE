import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DoanhThuController extends GetxController {
  static DoanhThuController get instance => Get.find();
  var doanhThu = <Map<String, dynamic>>[].obs;

  Future<void> loadDoanhThu() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    DateTime now = DateTime.now();
    List<DateTime> dateList = [];
    for (int i = 0; i < 10; i++) {
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
  }
}
