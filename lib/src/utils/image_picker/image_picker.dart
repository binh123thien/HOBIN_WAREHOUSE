import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../features/dashboard/controllers/image_controller.dart';

final controller = Get.put(ImageController());

Future<void> uploadImageToFirebase(
  ImageSource imageSource,
  String folder,
  // UserModel userData,
) async {
  final pickedFile = await ImagePicker().pickImage(source: imageSource);
  File? imageFile;

  if (pickedFile != null) {
    imageFile = File(pickedFile.path);
  } else {
    print('Chưa chọn hình ảnh');
    return;
  }

  try {
    String nameImage = DateTime.now().toString();
    Reference ref = FirebaseStorage.instance.ref().child("$folder/$nameImage");
    UploadTask uploadTask = ref.putFile(imageFile);
    String imageUrl = await (await uploadTask).ref.getDownloadURL();

    controller.ImagePickedURLController.add(imageUrl);
    // print('hình ảnh đã chọn');
    // print(controller.ImagePickedURLController.toList());

    controller.ImagePickedNameController.add(nameImage);
    print(controller.ImagePickedURLController.length);
    print('tên của hình ảnh');
    print(controller.ImagePickedNameController.toList());
  } on FirebaseException catch (e) {
    print(e.message);
  }
}
