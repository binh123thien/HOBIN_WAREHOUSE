import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../repository/history_repository/history_repository.dart';
import '../add/chonhanghoa_controller.dart';

class HistoryController extends GetxController {
  static HistoryController get instance => Get.find();
  final controllerHistoryRepo = Get.put(HistoryRepository());
  final controller = Get.put(ChonHangHoaController());
  List<dynamic> docHangThang = [].obs;
  RxInt tongNhapHang = 0.obs;
  RxInt tongBanHang = 0.obs;
  RxInt soluongtonkho = 0.obs;
  RxInt giatritonkho = 0.obs;

  loadPhiNhapHangTrongThang(String loaiNhapHoacBanHang) async {
    await controllerHistoryRepo
        .getAllDonBanHangHoacNhapHang(loaiNhapHoacBanHang)
        .listen((snapshot) {
      docHangThang = snapshot.docs.map((doc) => doc.data()).toList();
      List filteredDocs = docHangThang.where((doc) {
        DateTime datetime = DateFormat('dd-MM-yyyy').parse(doc['datetime']);
        return datetime.month == DateTime.now().month;
      }).toList();

      double totalTongTien = 0;
      for (var doc in filteredDocs) {
        double tongTien = doc['tongthanhtoan'];
        totalTongTien += tongTien;
      }
      if (loaiNhapHoacBanHang == "BanHang") {
        tongBanHang.value = totalTongTien.toInt();
      } else if (loaiNhapHoacBanHang == "NhapHang") {
        tongNhapHang.value = totalTongTien.toInt();
      }
      double sltonkho = 0;
      for (var item in controller.allHangHoaFireBase) {
        sltonkho += item["tonkho"];
      }
      soluongtonkho.value = sltonkho.toInt();
      final double gtritonkho = controller.allHangHoaFireBase
          .fold(0, (sum, item) => sum + item['gianhap'] * item['tonkho']);
      giatritonkho.value = gtritonkho.toInt();
    });
  }
}
