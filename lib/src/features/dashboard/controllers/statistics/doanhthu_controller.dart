import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/repository/statistics_repository/doanhthu_repository.dart';
import 'package:intl/intl.dart';

import '../../../../repository/add_repository/add_repository.dart';

class DoanhThuController extends GetxController {
  static DoanhThuController get instance => Get.find();
  RxList<dynamic> docDoanhThuTuanChart = [].obs;
  List<dynamic> docDoanhThuNgay = [].obs;
  List<dynamic> docDoanhThuTuan = [].obs;
  List<dynamic> docDoanhThuThang = [].obs;
  final controllerRepo = Get.put(DoanhThuRepository());
  final controllerAdd = Get.put(AddRepository());

  loadDoanhThuTuanChart() async {
    await controllerRepo.getTongDoanhThuTuan().listen((snapshot) {
      docDoanhThuTuanChart
          .assignAll(snapshot.docs.map((doc) => doc.data()).toList());
      DateTime currentDate = DateTime.now();
      String formattedDate =
          "${currentDate.day.toString().padLeft(2, '0')}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.year}";

      String tuanNgay =
          controllerAdd.getTuanFromDate(formattedDate, "datetime");
      String week = controllerAdd.getTuanFromDate(formattedDate, "week");

      if (docDoanhThuTuanChart.isEmpty ||
          docDoanhThuTuanChart[0]['datetime'] != tuanNgay) {
        final currentWeek = {
          'datetime': tuanNgay,
          'week': week,
          'dangcho': 0,
          'thanhcong': 0,
          'huy': 0,
          'doanhthu': 0,
        };
        docDoanhThuTuanChart.insert(0, currentWeek);
      }
      // Cập nhật giá trị và thông báo cho Obx widget cần cập nhật giao diện
      docDoanhThuTuanChart.refresh();
    });
  }

  loadDoanhThuNgay() async {
    await controllerRepo.getTongDoanhThuNgay().listen((snapshot) {
      docDoanhThuNgay = snapshot.docs.map((doc) => doc.data()).toList();
      DateTime currentDate = DateTime.now();
      String formattedDate =
          "${currentDate.day.toString().padLeft(2, '0')}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.year}";
      if (docDoanhThuNgay.isEmpty ||
          docDoanhThuNgay[0]["datetime"] != formattedDate) {
        Map<String, dynamic> newDoc = {
          "datetime": formattedDate,
          "dangcho": 0,
          "thanhcong": 0,
          "huy": 0,
          "doanhthu": 0
        };
        docDoanhThuNgay.insert(0, newDoc);
      }
    });
  }

  loadDoanhThuTuan() async {
    await controllerRepo.getTongDoanhThuTuan().listen((snapshot) {
      docDoanhThuTuan = snapshot.docs.map((doc) => doc.data()).toList();
      DateTime currentDate = DateTime.now();
      String formattedDate =
          "${currentDate.day.toString().padLeft(2, '0')}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.year}";

      String tuanNgay =
          controllerAdd.getTuanFromDate(formattedDate, "datetime");
      String week = controllerAdd.getTuanFromDate(formattedDate, "week");

      if (docDoanhThuTuan.isEmpty ||
          docDoanhThuTuan[0]['datetime'] != tuanNgay) {
        final currentWeek = {
          'datetime': tuanNgay,
          'week': week,
          'dangcho': 0,
          'thanhcong': 0,
          'huy': 0,
          'doanhthu': 0,
        };
        docDoanhThuTuan.insert(0, currentWeek);
      }
    });
  }

  loadDoanhThuThang() async {
    await controllerRepo.getTongDoanhThuThang().listen((snapshot) {
      docDoanhThuThang = snapshot.docs.map((doc) => doc.data()).toList();
      DateTime currentDate = DateTime.now();
      String formattedMonth =
          "Tháng ${currentDate.month.toString().padLeft(2, '0')}-${currentDate.year}";
      if (docDoanhThuThang.isEmpty ||
          docDoanhThuThang[0]["datetime"] != formattedMonth) {
        Map<String, dynamic> newDoc = {
          "datetime": formattedMonth,
          "dangcho": 0,
          "thanhcong": 0,
          "huy": 0,
          "doanhthu": 0
        };
        docDoanhThuThang.insert(0, newDoc);
      }
    });
  }

  Stream<List<double>> getDoanhThu7DayFromFirebase(String inputString) async* {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final dates = getDatesFromString(inputString);
    final List<double> doanhThuList7DayChart = [];

    for (final date in dates) {
      final snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(firebaseUser!.uid)
          .collection("History")
          .doc(firebaseUser.uid)
          .collection("TongDoanhThu")
          .doc(firebaseUser.uid)
          .collection("HangNgay")
          .where('datetime', isEqualTo: date)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs[0];
        final doanhThu = doc.data()['doanhthu'];
        doanhThuList7DayChart.add(doanhThu);
      } else {
        doanhThuList7DayChart.add(0.0);
      }
    }

    yield doanhThuList7DayChart;
  }

  Stream<List<DocumentSnapshot>> filterDocumentsByDate(String inputString) {
    final dates = getDatesFromString(inputString);

    final firebaseUser = FirebaseAuth.instance.currentUser;
    final collectionRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection("TongDoanhThu")
        .doc(firebaseUser.uid)
        .collection("HangNgay");

    final documentsStream = collectionRef
        .where('datetime', whereIn: dates)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs);
    return documentsStream;
  }

  List<String> getDatesFromString(String inputString) {
    final datePattern = RegExp(r'\d{2}-\d{2}-\d{4}');
    final dates = datePattern
        .allMatches(inputString)
        .map((match) => match.group(0))
        .toList();

    if (dates.length != 2) {
      return [];
    }

    final dateFormat = DateFormat('dd-MM-yyyy');
    final startDate = dateFormat.parse(dates[0]!);
    final endDate = dateFormat.parse(dates[1]!);

    final List<String> consecutiveDates = [];
    final difference = endDate.difference(startDate).inDays;

    for (int i = 0; i <= difference; i++) {
      final currentDate = startDate.add(Duration(days: i));
      final formattedDate = dateFormat.format(currentDate);
      consecutiveDates.add(formattedDate);
    }
    return consecutiveDates;
  }

  Stream<List<DocumentSnapshot>> queryDocsByMonth(String monthYear) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final collectionRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("History")
        .doc(firebaseUser.uid)
        .collection("TongDoanhThu")
        .doc(firebaseUser.uid)
        .collection("HangNgay");

    final documentsStream = collectionRef
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.where((doc) {
              final docDateTime = DateFormat('dd-MM-yyyy')
                  .parse(doc.get('datetime')); // Parse string to DateTime
              final docMonthYear = DateFormat("'Tháng' MM-yyyy")
                  .format(docDateTime); // Get MM-yyyy from DateTime
              return docMonthYear ==
                  monthYear; // Compare with the provided monthYear
            }).toList());
    return documentsStream;
  }
}
