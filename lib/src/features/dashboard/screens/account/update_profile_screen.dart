import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/constants/sizes.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/account/profile_controller.dart';
import 'package:hobin_warehouse/src/common_widgets/bottom_sheet_options.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../common_widgets/dialog/dialog.dart';
import '../../../../common_widgets/willpopscope.dart';
import '../../../../constants/image_strings.dart';
import '../../../../utils/image_picker/image_picker.dart';
import '../../../authentication/models/user_models.dart';
import '../../controllers/image_controller.dart';
import 'widget/form_profile_menu_widget.dart';

class UpdateProfileScreen extends StatefulWidget {
  final UserModel userData;
  final String photoFb;
  const UpdateProfileScreen(
      {super.key, required this.userData, required this.photoFb});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final controller = Get.put(ProfileController());
  final controllerImage = Get.put(ImageController());

  late UserModel updateUserData;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // Gán giá trị của widget.user vào state để sử dụng: cập nhập thuộc tính
    super.initState();
    updateUserData = widget.userData;
    // Gán giá trị sau khi userData đã được khởi tạo
    controller.nameController.text = widget.userData.name;
    controller.emailController.text = widget.userData.email;
    controller.phoneController.text = widget.userData.phone;
  }

  @override
  Widget build(BuildContext context) {
    return ExitConfirmationDialog(
      message: 'Bạn muốn quay lại trang trước?',
      onConfirmed: () {
        //xóa những tấm hình khách chưa lưu
        controllerImage.deleteAllImageList('profile');
        Navigator.of(context).pop(true);
      },
      dialogChild: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              MyDialog.showAlertDialog(
                context,
                'Xác nhận',
                'Bạn muốn quay lại trang trước?',
                () {
                  //xóa những tấm hình khách chưa lưu
                  controllerImage.deleteAllImageList('profile');
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                },
              );
            },
            icon: Image.asset(
              backIcon,
              height: 20,
              color: whiteColor,
            ),
          ),
          backgroundColor: backGroundColor,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage(tBackGround1), // where is this variable defined?
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: const Text(
            "Thay đổi thông tin",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w900, fontSize: 21),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              children: [
                //avatar
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl: (updateUserData.photoURL.isNotEmpty)
                              ? updateUserData.photoURL
                              : tDefaultAvatar,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              builder: (context) {
                                return BottomSheetOptions(
                                  textOneofTwo: 'avatar',
                                  onTapCamera: () async {
                                    await uploadImageToFirebase(
                                        ImageSource.camera, 'profile');
                                    //setState updateUserData
                                    showHinhAnh();
                                  },
                                  onTapGallery: () async {
                                    await uploadImageToFirebase(
                                        ImageSource.gallery, 'profile');
                                    showHinhAnh();
                                  },
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: pink400Color),
                            child: const Icon(
                              LineAwesomeIcons.camera,
                              color: Colors.black,
                            ),
                          ),
                        ))
                  ],
                ),
                //======================= end avatar ===========================================
                const SizedBox(height: 10),
                Text(
                  updateUserData.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  updateUserData.email,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 20),
                const Divider(),
                Column(
                  children: [
                    FormUpdateProfile(
                      controllerValue: controller.emailController,
                      enableText: false,
                      labelText: "Email",
                      hintText: "Email",
                      icon: const Icon(Icons.mail_outline),
                    ),
                    FormUpdateProfile(
                      controllerValue: controller.nameController,
                      enableText: true,
                      labelText: "Họ và tên",
                      hintText: "Họ và tên",
                      icon: const Icon(
                        Icons.account_circle_outlined,
                      ),
                    ),
                    FormUpdateProfile(
                      textInputType: TextInputType.number,
                      controllerValue: controller.phoneController,
                      enableText: true,
                      labelText: "Số điện thoại",
                      hintText: "Số điện thoại",
                      icon: const Icon(
                        Icons.phone_iphone_outlined,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        dynamic newvalue = await _updateUserData();
                        Navigator.of(context).pop(newvalue);
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(250, 0),
                          backgroundColor: pink500Color,
                          side: BorderSide.none,
                          shape: const StadiumBorder()),
                      child: const Text(
                        'Lưu',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ) // căn giữa theo co
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _updateUserData() async {
//================= xóa hình ảnh trước đó của user ===============
    if (widget.photoFb.isNotEmpty) {
      if (controllerImage.ImagePickedURLController.isNotEmpty) {
        // lấy dữ liệu thông qua URL của hình ảnh
        final imageRef = FirebaseStorage.instance.refFromURL(widget.photoFb);
        //xóa hình ảnh qua path imageRef
        FirebaseStorage.instance.ref().child(imageRef.fullPath).delete();
      }
    }
//================ end xóa hình ảnh trước đó của user =====================
    //update URL trên FireStore
    FirebaseFirestore.instance
        .collection('Users')
        .doc(firebaseUser!.uid)
        .update({
      'Name': controller.nameController.text.trim(),
      'Email': controller.emailController.text.trim(),
      'Phone': controller.phoneController.text.trim(),
      'PhotoURL': controllerImage.ImagePickedURLController.isNotEmpty
          ? controllerImage.ImagePickedURLController.last
          : updateUserData.photoURL,
    }).whenComplete(() {
      Get.snackbar("Thành công", "Cập nhập thông tin hoàn tất!",
          colorText: Colors.green);
    });
    controllerImage.deleteExceptLastImage('profile');
    //lấy doc mới cập nhật return về (get dữ liệu về trang trước)
    final updatedDoc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser!.uid)
        .get();
    //chuyển về dạng model
    final user = UserModel.fromSnapshot(updatedDoc);
    print(user.toJson());
    return user;
  }

  showHinhAnh() {
    setState(() {
      updateUserData = UserModel(
          id: firebaseUser!.uid,
          name: controller.nameController.text.trim(),
          email: controller.emailController.text.trim(),
          phone: controller.phoneController.text.trim(),
          password: updateUserData.password,
          photoURL: controllerImage.ImagePickedURLController.isEmpty
              ? updateUserData.photoURL
              : controllerImage.ImagePickedURLController.last);
    });
    Navigator.of(context).pop();
  }
}
