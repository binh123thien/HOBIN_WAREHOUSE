import 'package:cloud_firestore/cloud_firestore.dart';

class DonViModel {
  final String? id;
  String donvi;
  DonViModel({
    this.id,
    required this.donvi,
  });

  toJson() {
    return {
      "donvi": donvi,
    };
  }

  //Bước 1: - Map user fetched từ Firebase tới UserModel
  factory DonViModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return DonViModel(
      id: document.id,
      donvi: data["donvi"],
    );
  }
}
