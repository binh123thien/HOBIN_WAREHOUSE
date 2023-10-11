import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../common_widgets/snackbar/toast.dart';

class NotificationRepository extends GetxController {
  static NotificationRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  Future<void> loadSanPhamHetHan() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    //tao chuỗi ngày hiện tại
    final currentDate = DateTime.now();
    final formattedcurrentDate =
        "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
    final futureDate = currentDate.add(const Duration(days: 7));
    final formattedfutureDate =
        "${futureDate.year}-${futureDate.month.toString().padLeft(2, '0')}-${futureDate.day.toString().padLeft(2, '0')}";
    final collectionExpired = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Goods")
        .doc(firebaseUser.uid)
        .collection("Expired");
    final querySnapshot = await collectionExpired
        .where("exp", isLessThanOrEqualTo: formattedfutureDate)
        .get();
    final documents = querySnapshot.docs;
    //neu nhu co san pham het hạn thì mới thực hiện tiếp
    if (documents.isNotEmpty) {
      //duyet qua cac ngay nam trong danh sach
      List<Map<String, dynamic>> listOfDocsLocation = [];
      for (final document in documents) {
        final masanphamCollectionQuerySnapshot = await collectionExpired
            .doc(document.id)
            .collection("masanpham")
            .get();
        final masanphams = masanphamCollectionQuerySnapshot.docs;
        for (var docmasanpham in masanphams) {
          final locationCollectionQuerySnapshot = await collectionExpired
              .doc(document.id)
              .collection("masanpham")
              .doc(docmasanpham.id)
              .collection("location")
              .get();
          final docsLocation = locationCollectionQuerySnapshot.docs;
          // Duyệt và xử lý từng tài liệu trong docsLocation
          for (var docLocation in docsLocation) {
            listOfDocsLocation.add(docLocation.data());
          }
        }
      }
      //kiểm tra xem doc chuỗi ngày hiện tại có trên firebase hay không
      final collectionNotification = _db
          .collection("Users")
          .doc(firebaseUser.uid)
          .collection("Notification");
      final queryNgayNotificaton =
          await collectionNotification.doc(formattedcurrentDate).get();
      //neu chua co ngay thi tao moi du lieu sp het han trong 7 day hoặc có sản phẩm mới sắp hết hạn thì cập nhật lại
      if (!queryNgayNotificaton.exists ||
          queryNgayNotificaton["lengthSanPham"] != listOfDocsLocation.length) {
        await _db
            .collection("Users")
            .doc(firebaseUser.uid)
            .collection("Notification")
            .doc(formattedcurrentDate)
            .set({
          "read": 0,
          "datetime": formattedcurrentDate,
          "detail": listOfDocsLocation,
          "lengthSanPham": listOfDocsLocation.length,
        }).then((_) => ToastWidget.showToast("Bạn có 1 thông báo mới"));
      }
    }
  }
}
