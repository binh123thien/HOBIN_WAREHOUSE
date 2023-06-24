import 'package:cloud_firestore/cloud_firestore.dart';

class ThemDonHangModel {
  final String? id;
  String ngaytao;
  String soHD;
  String khachhang;
  String trangthai;
  String datetime;
  String payment;
  num tongsl;
  num tongtien;
  num tongthanhtoan;
  num no;
  num giamgia;
  String billType;

  ThemDonHangModel({
    this.id,
    required this.ngaytao,
    required this.datetime,
    required this.soHD,
    required this.khachhang,
    required this.trangthai,
    required this.payment,
    required this.tongsl,
    required this.tongtien,
    required this.tongthanhtoan,
    required this.no,
    required this.giamgia,
    required this.billType,
  });

  toJson() {
    return {
      "billType": billType,
      "ngaytao": ngaytao,
      "soHD": soHD,
      "khachhang": khachhang,
      "trangthai": trangthai,
      "payment": payment,
      "tongsl": tongsl,
      "tongtien": tongtien,
      "tongthanhtoan": tongthanhtoan,
      "no": no,
      "giamgia": giamgia,
      "datetime": datetime,
    };
  }

  //Bước 1: - Map user fetched từ Firebase tới UserModel
  factory ThemDonHangModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ThemDonHangModel(
      id: document.id,
      ngaytao: data["ngaytao"],
      soHD: data["soHD"],
      khachhang: data["khachhang"],
      trangthai: data["trangthai"],
      payment: data["payment"],
      tongsl: data["tongsl"],
      tongtien: data["tongtien"],
      tongthanhtoan: data["tongthanhtoan"],
      no: data["no"],
      giamgia: data["giamgia"],
      billType: data["billType"],
      datetime: data["datetime"],
    );
  }
}
