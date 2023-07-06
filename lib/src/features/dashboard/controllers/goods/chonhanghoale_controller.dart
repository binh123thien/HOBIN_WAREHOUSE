import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChonHangHoaLeController extends GetxController {
  static ChonHangHoaLeController get instance => Get.find();

  final _db = FirebaseFirestore.instance;

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
  calculate(String chuyendoiLe, String chuyendoiSi, Map<String, dynamic> goodSi,
      Map<String, dynamic> goodLe) async {
    print('vao calculate');
    //===================================== Sỉ ==============================================
    // Lấy sản phẩm Sỉ hiện tại
    DocumentSnapshot productHienTaiSi = await getTonKho(goodSi['macode']);
    //lấy tồn kho Sỉ hiện tại
    int tonKhoHientaiSi = await productHienTaiSi['tonkho'];
    // update GIẢM tồn kho Sỉ
    int tonKhoMoiSi = tonKhoHientaiSi - int.parse(chuyendoiSi.toString());
    //===================================== end Sỉ =========================
//tính hàng được chuyển đổi
    int chuyendoi =
        int.parse(chuyendoiSi.toString()) * int.parse(chuyendoiLe.toString());
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
  }
}
