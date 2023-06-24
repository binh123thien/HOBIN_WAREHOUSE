import 'package:cloud_firestore/cloud_firestore.dart';

class DanhMucModel {
  final String? id;
  String danhmuc;
  DanhMucModel({
    this.id,
    required this.danhmuc,
  });

  toJson() {
    return {
      "danhmuc": danhmuc,
    };
  }

  //Bước 1: - Map user fetched từ Firebase tới UserModel
  factory DanhMucModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return DanhMucModel(
      id: document.id,
      danhmuc: data["danhmuc"],
    );
  }
}
