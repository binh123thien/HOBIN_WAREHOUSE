import 'package:get/get.dart';

import '../../../../repository/notification_repository/notification_repository.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();
  List<dynamic> allNotification = [].obs;
  final controllerNotiRepo = Get.put(NotificationRepository());
  loadAllNotification() async {
    await controllerNotiRepo.getAllNotification().listen((snapshot) {
      allNotification = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}
