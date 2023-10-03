import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/repository/goods_repository/good_repository.dart';
import 'package:hobin_warehouse/src/utils/utils.dart';
import '../../features/dashboard/controllers/add/chonhanghoa_controller.dart';

class AddRepository extends GetxController {
  static AddRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  final ChonHangHoaController chonHangHoaController = Get.find();
  final controllerGoodRepo = Get.put(GoodRepository());

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

  //update số lượng tồn kho bên collection HangHoa
  updateTonKho(String docMaCode, int tongTonKho, int soLuongBan) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    await _db
        .collection('Users')
        .doc(firebaseUser!.uid)
        .collection('Goods')
        .doc(firebaseUser.uid)
        .collection('HangHoa')
        .doc(docMaCode)
        .update({
      'tonkho': tongTonKho,
      'daban': soLuongBan,
    });
  }

  //=============================== Thêm hàng hóa, location mới =============================================
  createLocation(String dateFormat, Map<String, dynamic> duLieuPicked,
      CollectionReference<Map<String, dynamic>> locationCollectionRef) async {
    await locationCollectionRef.doc(dateFormat + duLieuPicked['location']).set({
      'expire': duLieuPicked['expire'],
      'location': duLieuPicked['location'],
      'soluong': duLieuPicked['soluong']
    });
  }

  checkLocation(Map<String, dynamic> duLieuPicked) async {
    final dateFormat = formatNgayTaoString(duLieuPicked['expire']);
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final locationCollectionRef = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("Location")
        .doc(duLieuPicked['macode'])
        .collection(duLieuPicked['macode']);

    final querySnapshot = await locationCollectionRef
        .where('expire', isEqualTo: duLieuPicked['expire'])
        .where('location', isEqualTo: duLieuPicked['location'])
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Có tài liệu với cùng "expire" và location, cập nhật số lượng mới
      for (var documentSnapshot in querySnapshot.docs) {
        final currentQuantity = documentSnapshot.data()['soluong'];
        final newQuantity = currentQuantity + duLieuPicked['soluong'];

        // Cập nhật số lượng mới
        await documentSnapshot.reference.update({'soluong': newQuantity});
      }
      print('Cập nhật số lượng thành công');
    } else {
      // Không có tài liệu với cùng "expire" và location, tạo mới tài liệu
      createLocation(dateFormat, duLieuPicked, locationCollectionRef);
      print('Tạo mới dữ liệu thành công');
    }
  }
}
