class TongDoanhThuModel {
  String ngay;
  num doanhthu;
  num thanhcong;
  num dangcho;
  num huy;
  TongDoanhThuModel({
    required this.ngay,
    required this.doanhthu,
    required this.thanhcong,
    required this.dangcho,
    required this.huy,
  });

  toJson() {
    return {
      "ngay": ngay,
      "doanhthu": doanhthu,
      "thanhcong": thanhcong,
      "dangcho": dangcho,
      "huy": huy,
    };
  }
}
