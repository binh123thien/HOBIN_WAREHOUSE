class LichSuTraNoModel {
  String billType;
  String khachhang;
  String ngaytrano;
  String soHD;
  num conno;
  num nocu;
  num sotientra;
  LichSuTraNoModel({
    required this.billType,
    required this.khachhang,
    required this.ngaytrano,
    required this.soHD,
    required this.conno,
    required this.nocu,
    required this.sotientra,
  });

  toJson() {
    return {
      "billType": billType,
      "khachhang": khachhang,
      "ngaytrano": ngaytrano,
      "soHD": soHD,
      "conno": conno,
      "nocu": nocu,
      "sotientra": sotientra,
    };
  }
}
