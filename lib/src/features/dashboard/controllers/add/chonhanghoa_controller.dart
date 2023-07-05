import 'package:get/get.dart';

import '../../../../repository/goods_repository/good_repository.dart';

class ChonHangHoaController extends GetxController {
  static ChonHangHoaController get instance => Get.find();

  final controllerGoodRepo = Get.put(GoodRepository());
  List<dynamic> allHangHoaFireBase = [].obs;
  List<dynamic> categoryCountList = [].obs;
  loadAllHangHoa() async {
    await controllerGoodRepo.getAllhanghoa().listen((snapshot) {
      allHangHoaFireBase = snapshot.docs.map((doc) => doc.data()).toList();

      //tính tổng tồn kho trang thống kê
      Map<String, num> categoryCount = allHangHoaFireBase.fold({}, (acc, obj) {
        if (obj['danhmuc'].isEmpty) {
          acc.update("Chưa phân loại", (value) => value + obj['tonkho'],
              ifAbsent: () => obj['tonkho']);
        } else {
          obj['danhmuc'].forEach((category) {
            acc.update(category, (value) => value + obj['tonkho'],
                ifAbsent: () => obj['tonkho']);
          });
        }
        return acc;
      });
      categoryCountList.clear();
      categoryCount.forEach((key, value) {
        String categoryEntry = "$key:$value";
        categoryCountList.add(categoryEntry);
      });
    });
  }
}
