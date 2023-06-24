class ThemKhachHangModel {
  final String? id;
  String tenkhachhang;
  String sdt;
  String diachi;
  String loai;
  String maKH;
  ThemKhachHangModel({
    this.id,
    required this.tenkhachhang,
    required this.sdt,
    required this.diachi,
    required this.loai,
    required this.maKH,
  });

  toJson() {
    return {
      "maKH": maKH,
      "tenkhachhang": tenkhachhang,
      "sdt": sdt,
      "diachi": diachi,
      "loai": loai,
    };
  }
}
