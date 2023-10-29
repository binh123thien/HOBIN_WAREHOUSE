// ignore_for_file: use_build_context_synchronously
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/account/profile_controller.dart';
import 'package:hobin_warehouse/src/common_widgets/bottom_sheet_options.dart';
import 'package:hobin_warehouse/src/utils/image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../common_widgets/dialog/dialog.dart';
import '../../../../common_widgets/fontSize/font_size.dart';
import '../../../../common_widgets/network/network.dart';
import '../../../../common_widgets/willpopscope.dart';
import '../../../../constants/image_strings.dart';
import 'widget/form_profile_menu_widget.dart';

class UpdateProfileScreen extends StatefulWidget {
  final Map userData;
  final String photoFb;
  const UpdateProfileScreen(
      {super.key, required this.userData, required this.photoFb});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final controller = Get.put(ProfileController());

  late Map updateUserData;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  Uint8List? currentImage;
  Uint8List? preImage;
  bool _isLoading = false;
  @override
  void initState() {
    // Gán giá trị của widget.user vào state để sử dụng: cập nhập thuộc tính

    // Tạo bản sao của đối tượng userData
    updateUserData = Map.from(widget.userData);
    // Gán giá trị sau khi userData đã được khởi tạo
    controller.nameController.text = widget.userData['Name'];
    controller.emailController.text = widget.userData['Email'];
    controller.phoneController.text = widget.userData['Phone'];
    super.initState();
  }

  selectImage(sourceImage) async {
    Uint8List? img = await StoreData().pickImage(sourceImage);
    if (img != null) {
      preImage = img;
      currentImage = img;
    } else {
      currentImage = preImage;
    }
    setState(() {
      currentImage;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ExitConfirmationDialog(
      phanBietNhapXuat: 0, //maincolor
      message: 'Bạn muốn quay lại trang trước?',
      onConfirmed: () {
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
                0,
                () {
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
          backgroundColor: mainColor,
          title: Text(
            "Quản lý tài khoản",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: Font.sizes(context)[2]),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                //avatar
                Stack(
                  children: [
                    SizedBox(
                        width: size.width * 0.22, //90
                        height: size.width * 0.22,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: currentImage != null
                              ? Image.memory(
                                  currentImage!,
                                  width: size.width * 0.22,
                                  height: size.width * 0.22,
                                  fit: BoxFit.cover,
                                )
                              : (updateUserData['PhotoURL'].isNotEmpty)
                                  ? CachedNetworkImage(
                                      imageUrl: updateUserData['PhotoURL'],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    )
                                  : Image.asset(
                                      tDefaultAvatar,
                                    ),
                        )),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                ),
                              ),
                              builder: (context) {
                                return BottomSheetOptions(
                                  textOneofTwo: 'avatar',
                                  onTapCamera: () =>
                                      selectImage(ImageSource.camera),
                                  onTapGallery: () =>
                                      selectImage(ImageSource.gallery),
                                );
                              },
                            );
                          },
                          child: Container(
                            width: size.width * 0.22 / 3,
                            height: size.width * 0.22 / 3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: backGroundSearch),
                            child: const Icon(
                              LineAwesomeIcons.camera,
                              color: Colors.black,
                            ),
                          ),
                        ))
                  ],
                ),
                //======================= end avatar ===========================================
                const SizedBox(height: 15),
                Text(
                  updateUserData['Name'],
                  style: TextStyle(fontSize: Font.sizes(context)[3]),
                ),
                Text(
                  updateUserData['Email'],
                  style: TextStyle(fontSize: Font.sizes(context)[2]),
                ),
                SizedBox(height: size.height * 0.07),
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
                  ],
                ) // căn giữa theo co
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: size.height * 0.08,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: size.width - 30,
                height: size.height * 0.05,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: mainColor,
                    side: const BorderSide(color: mainColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5), // giá trị này xác định bán kính bo tròn
                    ),
                  ),
                  onPressed: () {
                    NetWork.checkConnection().then((value) {
                      if (value == "Not Connected") {
                        MyDialog.showAlertDialogOneBtn(
                            context,
                            "Không có Internet",
                            "Vui lòng kết nối internet và thử lại sau");
                      } else {
                        setState(() {
                          _isLoading = true;
                        });
                        _performDataProcessing().then((_) async {
                          final updatedDoc = await FirebaseFirestore.instance
                              .collection("Users")
                              .doc(firebaseUser!.uid)
                              .get();
                          //chuyển về dạng Map
                          final user = updatedDoc.data();
                          Navigator.of(context).pop(user);
                          Get.snackbar(
                              "Thành công", "Cập nhập thông tin hoàn tất!",
                              colorText: Colors.green);
                        });
                      }
                    });
                  },
                  child: _isLoading
                      ? const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            color: whiteColor,
                          ),
                        )
                      : Text(
                          'Lưu',
                          style: TextStyle(fontSize: Font.sizes(context)[2]),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _performDataProcessing() async {
    if (currentImage != null) {
      await StoreData().saveImageProfile(
        file: currentImage!,
        user: updateUserData['Uid'],
      );
      await StoreData().saveInfomationProfile(
        name: controller.nameController.text.trim(),
        phone: controller.phoneController.text.trim(),
      );
    } else {
      await StoreData().saveInfomationProfile(
        name: controller.nameController.text.trim(),
        phone: controller.phoneController.text.trim(),
      );
    }
  }
}
