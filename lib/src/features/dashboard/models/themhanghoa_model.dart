import 'package:cloud_firestore/cloud_firestore.dart';

class HangHoaModel {
  final String? id;
  String macode;
  String tensanpham;
  double gianhap;
  double giaban;
  int daban;
  int tonkho;
  int soluong;
  int chuyendoi;
  String phanloai;
  String donvi;
  List<String> danhmuc;
  String photoGood;

  HangHoaModel({
    this.id,
    required this.macode,
    required this.tensanpham,
    required this.gianhap,
    required this.giaban,
    required this.phanloai,
    required this.donvi,
    required this.danhmuc,
    required this.daban,
    required this.tonkho,
    required this.soluong,
    required this.chuyendoi,
    required this.photoGood,
  });

  toJson() {
    return {
      "macode": macode,
      "tensanpham": tensanpham,
      "gianhap": gianhap,
      "giaban": giaban,
      "phanloai": phanloai,
      "donvi": donvi,
      "danhmuc": danhmuc,
      "daban": 0,
      "tonkho": 0,
      "soluong": 0,
      'chuyendoi': 0,
      "photoGood": photoGood,
    };
  }

  //Bước 1: - Map user fetched từ Firebase tới UserModel
  factory HangHoaModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return HangHoaModel(
        id: document.id,
        macode: data["macode"],
        tensanpham: data["tensanpham"],
        gianhap: data["gianhap"],
        giaban: data["giaban"],
        phanloai: data["phanloai"],
        donvi: data["donvi"],
        danhmuc: data["danhmuc"],
        daban: data["daban"] ?? 0,
        tonkho: data["tonkho"] ?? 0,
        soluong: data["soluong"] ?? 0,
        chuyendoi: data["chuyendoi"] ?? 0,
        photoGood: data['photoGood']);
  }
}
