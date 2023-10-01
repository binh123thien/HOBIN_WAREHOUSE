import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../repository/add_repository/nhaphang/location_name_repository.dart';

class NhapHangController extends GetxController {
  static NhapHangController get instance => Get.find();
  TextEditingController giamgiaNhapHangController = TextEditingController();
  TextEditingController noNhapHangController = TextEditingController();

  final controllerLocationNameRepo = Get.put(LocationNameRepo());
  List<dynamic> allLocationNameFirebase = [].obs;
  loadAllLocationsName() async {
    await controllerLocationNameRepo.getAllLocationName().listen((snapshot) {
      allLocationNameFirebase = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  createLocationName(String vitri) {
    controllerLocationNameRepo.createLocationName(vitri);
  }
}
