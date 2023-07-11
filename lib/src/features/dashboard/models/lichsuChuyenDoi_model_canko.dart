// ============================ có cần không nhỉ ===========================

import 'package:cloud_firestore/cloud_firestore.dart';

class LichSuCDModel {
  final String? id;
  String ngaytao;
  String tenSanPhamSi;
  String tenSanPhamLe;
  int soluongSi;
  int soluongLe;
  int chuyendoiSi;
  int chuyendoiLe;
  LichSuCDModel({
    this.id,
    required this.ngaytao,
    required this.tenSanPhamSi,
    required this.tenSanPhamLe,
    required this.soluongSi,
    required this.soluongLe,
    required this.chuyendoiSi,
    required this.chuyendoiLe,
  });

  toJson() {
    return {
      "ngaytao": ngaytao,
      "tenSanPhamSi": tenSanPhamSi,
      'tenSanPhamLe': tenSanPhamLe,
      'soluongSi': soluongSi,
      'soluongLe': soluongLe,
      'chuyendoiSi': chuyendoiSi,
      'chuyendoiLe': chuyendoiLe,
    };
  }

  //Bước 1: - Map user fetched từ Firebase tới UserModel
  factory LichSuCDModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return LichSuCDModel(
      id: document.id,
      ngaytao: data["ngaytao"],
      tenSanPhamSi: data["tenSanPhamSi"],
      tenSanPhamLe: data["tenSanPhamLe"],
      soluongSi: data["soluongSi"],
      soluongLe: data["soluongLe"],
      chuyendoiSi: data["chuyendoiSi"],
      chuyendoiLe: data["chuyendoiLe"],
    );
  }
}
