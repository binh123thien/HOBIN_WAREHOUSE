import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../repository/history_repository/history_repository.dart';
import '../add/chonhanghoa_controller.dart';

class HistoryController extends GetxController {
  static HistoryController get instance => Get.find();
  final controllerHistoryRepo = Get.put(HistoryRepository());
  final controller = Get.put(ChonHangHoaController());
  List<dynamic> docHangThang = [].obs;
  RxDouble tongNhapHang = 0.0.obs;
  RxDouble tongBanHang = 0.0.obs;
  RxDouble soluongtonkho = 0.0.obs;
  RxDouble giatritonkho = 0.0.obs;

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
        double? tongTien = double.tryParse(doc['tongthanhtoan'].toString());
        totalTongTien += tongTien!;
      }
      if (loaiNhapHoacBanHang == "XuatHang") {
        tongBanHang.value = totalTongTien;
      } else if (loaiNhapHoacBanHang == "NhapHang") {
        tongNhapHang.value = totalTongTien;
      }
      double sltonkho = 0;
      for (var item in controller.allHangHoaFireBase) {
        sltonkho += item["tonkho"];
      }
      soluongtonkho.value = sltonkho;
      final double gtritonkho = controller.allHangHoaFireBase
          .fold(0, (sum, item) => sum + item['gianhap'] * item['tonkho']);
      giatritonkho.value = gtritonkho;
    });
  }
}
