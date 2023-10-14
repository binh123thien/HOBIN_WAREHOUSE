// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../utils/utils.dart';

class ChonHangHoaLeController extends GetxController {
  static ChonHangHoaLeController get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  List<dynamic> allLichSuCDFirebase = [].obs;

  //load all lịch sử
  loadAllLichSu(String nameSi) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("LichSuCD")
        .where("tenSanPhamSi", isEqualTo: nameSi)
        .snapshots()
        .listen((snapshot) {
      allLichSuCDFirebase = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  //get sản phẩm cũ của hàng hóa đó
  getTonKho(String docMaCode) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final snapshot = await _db
        .collection('Users')
        .doc(firebaseUser!.uid)
        .collection('Goods')
        .doc(firebaseUser.uid)
        .collection('HangHoa')
        .doc(docMaCode)
        .get();
    return snapshot;
  }

  //format date Ex: 10/10/2023 thành 10-10-2023
  formatDate(hangHoaLocation) {
    String formatExpDate = hangHoaLocation['exp'].replaceAll("/", "-");
    return formatExpDate;
  }

  //get soluong location
  getSlLocation(Map<String, dynamic> hangHoaLocation,
      Map<String, dynamic> hangHoa) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    String formatExpDate = formatDate(hangHoaLocation);

    final locationSnapShot = await _db
        .collection('Users')
        .doc(firebaseUser!.uid)
        .collection('Goods')
        .doc(firebaseUser.uid)
        .collection('HangHoa')
        .doc(hangHoa['macode'])
        .collection('Exp')
        .doc(formatExpDate)
        .collection('location')
        .doc(hangHoaLocation['location'])
        .get();

    DocumentSnapshot? newLocationSnapShot;

    if (locationSnapShot == null || !locationSnapShot.exists) {
      // Nếu snapshot là null hoặc không tồn tại (document không tồn tại), thực hiện tạo mới
      //thêm trường exp cho ngày
      await _db
          .collection('Users')
          .doc(firebaseUser.uid)
          .collection('Goods')
          .doc(firebaseUser.uid)
          .collection('HangHoa')
          .doc(hangHoa['macode'])
          .collection('Exp')
          .doc(formatExpDate)
          .set({
        'exp': formatExpDate,
      });

      // get data
      await _db
          .collection('Users')
          .doc(firebaseUser.uid)
          .collection('Goods')
          .doc(firebaseUser.uid)
          .collection('HangHoa')
          .doc(hangHoa['macode'])
          .collection('Exp')
          .doc(formatExpDate)
          .collection('location')
          .doc(hangHoaLocation['location'])
          .set(hangHoaLocation);

      // Sau khi tạo mới, bạn có thể truy cập lại document vừa tạo bằng cách thực hiện một lần nữa `get()` sau khi đã set
      newLocationSnapShot = await _db
          .collection('Users')
          .doc(firebaseUser.uid)
          .collection('Goods')
          .doc(firebaseUser.uid)
          .collection('HangHoa')
          .doc(hangHoa['macode'])
          .collection('Exp')
          .doc(formatExpDate)
          .collection('location')
          .doc(hangHoaLocation['location'])
          .get();
    }

    return newLocationSnapShot ?? locationSnapShot;
  }

  //update field soluong trong location
  updateSlLocation(hangHoaLocation, hangHoa, soluongUpdate) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    String formatExpDate = formatDate(hangHoaLocation);
    await _db
        .collection('Users')
        .doc(firebaseUser!.uid)
        .collection('Goods')
        .doc(firebaseUser.uid)
        .collection('HangHoa')
        .doc(hangHoa['macode'])
        .collection('Exp')
        .doc(formatExpDate)
        .collection('location')
        .doc(hangHoaLocation['location'])
        .update({
      'soluong': soluongUpdate,
    });
  }

  //hàm update chuyendoi và tính toán
  Future<int> calculate(
    String dateTao,
    int chuyendoiLe,
    int chuyendoiSi,
    Map<String, dynamic> goodSi,
    Map<String, dynamic> goodLe,
    Map<String, dynamic> locationSi,
    Map<String, dynamic> locationLe,
  ) async {
    print('vao calculate tính phân phối hàng hóa');
//================================== Xử lý tổng tồn kho ============================================
    //===================================== Sỉ ==============================================
    // Lấy sản phẩm Sỉ hiện tại
    DocumentSnapshot productHienTaiSi = await getTonKho(goodSi['macode']);
    //lấy tồn kho Sỉ hiện tại
    int tonKhoHientaiSi = await productHienTaiSi['tonkho'];
    // update GIẢM tồn kho Sỉ
    int tonKhoMoiSi = tonKhoHientaiSi - chuyendoiSi;
    //===================================== end Sỉ =========================
    //tính hàng được chuyển đổi
    int chuyendoi = chuyendoiSi * chuyendoiLe;
    //===================================== Lẻ =============================
    // Lấy sản phẩm Lẻ hiện tại
    DocumentSnapshot productHienTaiLe = await getTonKho(goodLe['macode']);
    //lấy tồn kho Lẻ hiện tại
    int tonKhoHientaiLe = await productHienTaiLe['tonkho'];
    // update TĂNG tồn kho LẺ
    int tonKhoMoiLe = tonKhoHientaiLe + chuyendoi;
    //===================================== end Lẻ =========================

    final firebaseUser = FirebaseAuth.instance.currentUser;
    //================update Sỉ
    await _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("HangHoa")
        .doc(goodSi['macode'])
        .update({
      'chuyendoi': chuyendoiLe,
      'tonkho': tonKhoMoiSi,
    });

    //=====================update Lẻ
    await _db
        .collection("Users")
        .doc(firebaseUser.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("HangHoa")
        .doc(goodLe['macode'])
        .update({
      'tonkho': tonKhoMoiLe,
    });
//====================================== end Xử lý tổng tồn kho ===========================================

//============================== Xử lý từng vị trí ============================================
    //******************** SỈ **************/
    DocumentSnapshot locationSiSnapShot =
        await getSlLocation(locationSi, goodSi);
    //lấy tồn kho Sỉ hiện tại
    int soluongHienTaiLocationSi = locationSiSnapShot['soluong'];
    int soluongMoiLocationSi = soluongHienTaiLocationSi - chuyendoiSi;

    updateSlLocation(locationSi, goodSi, soluongMoiLocationSi);
    //**************** end Sỉ ****************** */

    //&&&&&&&&&&&&&&&& Lẻ &&&&&&&&&&&&&&&&&&&&&&&
    DocumentSnapshot locationLeSnapShot =
        await getSlLocation(locationLe, goodLe);
    //lấy tồn kho Sỉ hiện tại
    int soluongHienTaiLocationLe = locationLeSnapShot['soluong'];
    int soluongMoiLocationLe = soluongHienTaiLocationLe + chuyendoi;

    updateSlLocation(locationLe, goodLe, soluongMoiLocationLe);
    //&&&&&&&&&&&&&&&& end Lẻ &&&&&&&&&&&&&&&&&
//============================== End Xử lý từng vị trí ========================================
    //tạo lịch sử chuyển đổi trên firebase
    createLichSuCD(dateTao, goodSi['tensanpham'], goodLe['tensanpham'],
        tonKhoMoiSi, tonKhoMoiLe, chuyendoiSi, chuyendoiLe);
    //trả về số lượng lẻ được tăng thêm
    return chuyendoi;
  }

  createLichSuCD(String datetime, String tenhangSi, String tenhangLe, int slSi,
      int slLe, int chuyendoiSi, int chuyendoiLe) async {
    print('vao ham tao lich su CD');
    final firebaseUser = FirebaseAuth.instance.currentUser;
    await _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection('LichSuCD')
        .doc(datetime)
        .set({
      'ngaytao': datetime = formatNgayTao(),
      'tenSanPhamSi': tenhangSi,
      'tenSanPhamLe': tenhangLe,
      'chuyendoiLe': chuyendoiLe,
      'chuyendoiSi': chuyendoiSi,
      'soluongLe': slLe,
      'soluongSi': slSi,
    }).whenComplete(() => null);
  }

  getLichSuCD(String dateTao) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final gethanghoa = FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("LichSuCD")
        .where("ngaytao", isEqualTo: dateTao = formatNgayTao())
        .get();
    return gethanghoa;
  }
}
