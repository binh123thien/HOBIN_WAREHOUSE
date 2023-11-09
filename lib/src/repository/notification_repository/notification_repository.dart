import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
    //format field datetime
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    final formattedDate = formatter.format(currentDate);

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
          "datetime": formattedDate,
          "detail": listOfDocsLocation,
          "lengthSanPham": listOfDocsLocation.length,
        }).then((_) => ToastWidget.showToast("Bạn có 1 thông báo mới"));
      }
    }
  }

  getAllNotification() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final getAllLocationName = FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Notification")
        .orderBy("datetime", descending: true)
        .limit(30) // Giới hạn 30 tài liệu
        .snapshots();
    return getAllLocationName;
  }

  String khoangCachThoiGianThongBao(String datetime) {
    // Lấy thời gian hiện tại
    DateTime now = DateTime.now();
    // Chuỗi định dạng ngày tháng cần so sánh
    String dateString = datetime;
    // Chuyển chuỗi thành đối tượng DateTime
    DateTime targetDate = DateTime.parse(dateString);
    // Tính toán khoảng cách giữa thời gian hiện tại và thời gian cần so sánh
    Duration difference = now.difference(targetDate);
    // Kiểm tra nếu khoảng cách khác 0 ngày hoặc 0 giờ, thì hiển thị
    String diffText = "";
    if (difference.inDays > 0) {
      diffText = "${difference.inDays} ngày trước";
    } else if (difference.inHours > 0) {
      diffText = "${difference.inHours} giờ trước";
    } else if (difference.inMinutes > 0) {
      diffText = "${difference.inMinutes} phút trước";
    } else if (difference.inSeconds > 0) {
      diffText = "${difference.inSeconds} giây trước";
    } else {
      diffText = "bây giờ";
    }
    return diffText;
  }

  updateReadNotification(String formattedcurrentDate) {
    final firebaseUser = FirebaseAuth.instance.currentUser;

// Đường dẫn đến tài liệu cần cập nhật
    final documentReference = _db
        .collection("Users")
        .doc(firebaseUser!.uid)
        .collection("Notification")
        .doc(formattedcurrentDate);
    // Cập nhật trường "read" thành 1
    documentReference.update({"read": 1});
  }

  List<Map<String, int>> demSanPhamHetHanVaSapHetHan(
      List<dynamic> allNotification) {
    List<Map<String, int>> countSpHetHan = [];
    // Lấy thời gian hiện tại
    DateTime currentDate = DateTime.now();
    // Chuỗi định dạng ngày tháng cần so sánh
    DateFormat format = DateFormat('dd/MM/yyyy');
    for (var maps in allNotification) {
      Map<String, int> count = {
        "spHetHan": 0,
        "spChuaHetHan": 0,
      };
      for (var map in maps["detail"]) {
        String dateString = map["exp"];
        DateTime inputDate = format.parse(dateString);
        // So sánh
        if (inputDate.isBefore(currentDate) ||
            inputDate.isAtSameMomentAs(currentDate)) {
          count["spHetHan"] = count["spHetHan"]! + 1;
        } else {
          count["spChuaHetHan"] = count["spChuaHetHan"]! + 1;
        }
      }
      countSpHetHan.add(count);
    }
    return countSpHetHan;
  }
}
