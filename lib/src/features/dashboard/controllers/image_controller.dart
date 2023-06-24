import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class ImageController extends GetxController {
  //tìm ImageController trong những file khác có PUT
  static ImageController get instance => Get.find();

  //List lưu trữ tên và URL hình ảnh sau khi chọn hình
  List<String> ImagePickedURLController = [];
  // name để xóa hình
  List<String> ImagePickedNameController = [];

  deleteExceptLastImage(String folder) {
// xóa những hình ảnh trong list tạm chừa hình cuối cừng khách chọn
    for (int i = 0; i < ImagePickedNameController.length - 1; i++) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("$folder/${ImagePickedNameController[i]}");
      ref.delete();
    }
    //xóa 2 list nhớ tạm
    ImagePickedURLController.clear();
    ImagePickedNameController.clear();
  }

//xóa những tấm hình khách chưa lưu mà bấm back rồi
  deleteAllImageList(String folder) {
    // xóa những hình ảnh trong list tạm chừa hình cuối cừng khách chọn
    for (int i = 0; i < ImagePickedNameController.length; i++) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("$folder/${ImagePickedNameController[i]}");
      ref.delete();
    }
    //xóa 2 list nhớ tạm
    ImagePickedURLController.clear();
    ImagePickedNameController.clear();
  }
}
