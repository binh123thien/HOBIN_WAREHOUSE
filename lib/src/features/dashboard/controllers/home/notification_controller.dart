import 'package:get/get.dart';

import '../../../../repository/notification_repository/notification_repository.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();
  List<dynamic> allNotification = [].obs;
  RxInt sothongbao = 0.obs;
  final controllerNotiRepo = Get.put(NotificationRepository());
  loadAllNotification() async {
    await controllerNotiRepo.getAllNotification().listen((snapshot) {
      allNotification = snapshot.docs.map((doc) => doc.data()).toList();
      sothongbao.value = 0;
      for (var doc in allNotification) {
        if (doc["read"] == 0) {
          sothongbao.value++;
        }
      }
    });
  }
}
