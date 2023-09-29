import 'package:get/get.dart';

import '../../../../repository/statistics_repository/khachhang_repository.dart';

class KhachHangController extends GetxController {
  static KhachHangController get instance => Get.find();

  final controllerKhachHangRepo = Get.put(KhachHangRepository());
  List<dynamic> allKhachHangFirebase = [].obs;
  loadAllKhachHang() async {
    await controllerKhachHangRepo.getAllKhachHang().listen((snapshot) {
      allKhachHangFirebase = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}
