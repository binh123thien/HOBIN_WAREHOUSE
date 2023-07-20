import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../utils/utils.dart';

class ChonHangHoaLeController extends GetxController {
  static ChonHangHoaLeController get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  List<dynamic> allLichSuCDFirebase = [].obs;

  //load all lịch sử
  loadAllLichSu() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("LichSuCD")
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

  //hàm update chuyendoi và tính toán
  Future<int> calculate(String dateTao, int chuyendoiLe, int chuyendoiSi,
      Map<String, dynamic> goodSi, Map<String, dynamic> goodLe) async {
    print('vao calculate');
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
    print(chuyendoi);
    //===================================== Lẻ =============================
    // Lấy sản phẩm Lẻ hiện tại
    DocumentSnapshot productHienTaiLe = await getTonKho(goodLe['macode']);
    //lấy tồn kho Lẻ hiện tại
    int tonKhoHientaiLe = await productHienTaiLe['tonkho'];
    // update TĂNG tồn kho LẺ
    int tonKhoMoiLe = tonKhoHientaiLe + chuyendoi;
    print(tonKhoMoiLe);
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

    //tạo lịch sử chuyển đổi trên firebase
    createLichSuCD(dateTao, goodSi['tensanpham'], goodLe['tensanpham'],
        tonKhoMoiSi, tonKhoMoiLe, chuyendoiSi, chuyendoiLe);
    //trả về số lượng lẻ được tăng thêm
    return chuyendoi;
  }

  createLichSuCD(String datetime, String tenhangSi, String tenhangLe, int slSi,
      int slLe, int chuyendoiSi, int chuyendoiLe) async {
    print('vao ham tao lich su CD');
    // print(datetime);
    // print(tenhangSi);
    // print(tenhangLe);
    // print(slLe);
    // print(slSi);
    // print(chuyendoiLe);
    // print(chuyendoiSi);
    // final lichsuCDModel = LichSuCDModel(
    //   ngaytao: datetime,
    //   tenSanPhamSi: tenhangSi,
    //   tenSanPhamLe: tenhangLe,
    //   chuyendoiLe: chuyendoiLe,
    //   chuyendoiSi: chuyendoiSi,
    //   soluongLe: slLe,
    //   soluongSi: slSi,
    // );
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
        .where("ngaytao", isEqualTo: dateTao)
        .get();
    return gethanghoa;
  }
}
