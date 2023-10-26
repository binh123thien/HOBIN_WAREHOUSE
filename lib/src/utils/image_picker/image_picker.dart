// ignore_for_file: unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreData {
  pickImage(
    ImageSource imageSource,
  ) async {
    final imagePicker = ImagePicker();
    XFile? imageFile = await imagePicker.pickImage(source: imageSource);

    if (imageFile != null) {
      return await imageFile.readAsBytes();
    }
    print('Chưa chọn hình ảnh');
  }

  Future<void> checkAndDeletePreviousImage(String user, String folder,
      {String? macodeHH}) async {
    final Reference directoryRef;
    if (folder == 'goods') {
      directoryRef = _storage.ref().child("$user/$folder/$macodeHH");
    } else {
      directoryRef = _storage.ref().child("$user/$folder");
    }
    try {
      // Liệt kê tất cả các tệp trong thư mục
      final ListResult result = await directoryRef.listAll();
      // Duyệt qua danh sách các tệp và xóa chúng
      for (final item in result.items) {
        await item.delete();
      }
    } catch (e) {
      print("Lỗi khi kiểm tra và xóa các tệp cũ: $e");
    }
  }

  Future<String> uploadImageToStorage(
      String user, String folder, Uint8List file,
      {String? macodeHH}) async {
    Reference ref;
    checkAndDeletePreviousImage(user, folder, macodeHH: macodeHH);
    String nameImage = DateTime.now().toString();
    if (folder == 'goods') {
      ref = _storage.ref().child("$user/$folder/$macodeHH/$nameImage");
    } else {
      ref = _storage.ref().child("$user/$folder/$nameImage");
    }
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  //================= Good ========================
  Future<String> saveImageGood({
    required Uint8List file,
    required String user,
    required String macodeGood,
  }) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    String resp = 'Some error occurred';
    try {
      String imageURL =
          await uploadImageToStorage(user, 'goods', file, macodeHH: macodeGood);
      await _firestore
          .collection("Users")
          .doc(firebaseUser!.uid)
          .collection("Goods")
          .doc(firebaseUser.uid)
          .collection("HangHoa")
          .doc(macodeGood)
          .update({'photoGood': imageURL});
    } catch (e) {
      resp = e.toString();
    }
    return resp;
  }

  //================= end Good ====================
  //================== Profile ======================

  Future<String> saveImageProfile({
    required Uint8List file,
    required String user,
  }) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    String resp = 'Some error occurred';
    try {
      String imageURL = await uploadImageToStorage(user, 'profile', file);
      await _firestore
          .collection('Users')
          .doc(firebaseUser!.uid)
          .update({'PhotoURL': imageURL});
    } catch (e) {
      resp = e.toString();
    }
    return resp;
  }

  saveInfomationProfile({required String name, required String phone}) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    await _firestore.collection('Users').doc(firebaseUser!.uid).update({
      'Name': name,
      'Phone': phone,
    });
  }
}
