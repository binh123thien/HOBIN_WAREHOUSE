import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModel {
  final String id;
  LocationModel({
    required this.id,
  });

  toJson() {
    return {
      "id": id,
    };
  }

  //Bước 1: - Map user fetched từ Firebase tới UserModel
  factory LocationModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return LocationModel(
      id: data["id"],
    );
  }
}
