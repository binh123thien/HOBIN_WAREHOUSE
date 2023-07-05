import 'package:get/get.dart';
import 'package:hobin_warehouse/src/repository/statistics_repository/doanhthu_repository.dart';

class DoanhThuController extends GetxController {
  static DoanhThuController get instance => Get.find();
  List<dynamic> docDoanhThuNgay = [].obs;
  List<dynamic> docDoanhThuTuan = [].obs;
  final controllerRepo = Get.put(DoanhThuRepository());
  loadDoanhThuNgay() async {
    await controllerRepo.getTongDoanhThuNgay().listen((snapshot) {
      docDoanhThuNgay = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  loadDoanhThuTuan() async {
    await controllerRepo.getTongDoanhThuTuan().listen((snapshot) {
      docDoanhThuTuan = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}
