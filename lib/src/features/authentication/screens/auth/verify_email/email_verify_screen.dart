import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/form/form_header_widget.dart';
import 'package:hobin_warehouse/src/constants/image_strings.dart';
import 'package:hobin_warehouse/src/constants/sizes.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';
import 'package:hobin_warehouse/src/features/authentication/controllers/signup_controller.dart';
import 'package:hobin_warehouse/src/features/authentication/models/user_models.dart';
import 'package:hobin_warehouse/src/features/dashboard/models/donvi_model.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/dashboard.dart';
import 'package:hobin_warehouse/src/repository/user_repository/user_repository.dart';

import '../../../../dashboard/models/danhmuc_model.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({super.key});

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  final controller = Get.put(SignUpController());
  final userRepo = Get.put(UserRepository());

  bool isEmailVerified = false;
  bool canResendVerify = false;
  Timer? timer;
  int n = 0;
  @override
  void initState() {
    super.initState();

    // user need to be create before
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 10),
        (_) => checkEmailVerify(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // Check email đã xác thực chưa, nếu chưa thì reload
  Future checkEmailVerify() async {
    //call after email verify
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      // await FirebaseAuth.instance.currentUser!.reload();
      timer?.cancel();
      //Push du lieu sang FireStore
      final user = UserModel(
          email: controller.email.text.trim(),
          password: controller.password.text.trim(),
          name: "",
          phone: "",
          photoURL: "");
      final List<String> allDonvi = [
        "kg",
        "chai",
        "thùng",
        "cái",
      ];
      for (var i = 0; i < allDonvi.length; i++) {
        final donvidefault = DonViModel(donvi: allDonvi[i]);
        userRepo.createDonViDefault(donvidefault);
      }

      final List<String> allDanhMuc = [
        "đồ ăn",
        "thức ăn",
        "đồ gia dụng",
        "nước uống",
      ];
      for (var i = 0; i < allDanhMuc.length; i++) {
        final danhmucdefault = DanhMucModel(danhmuc: allDanhMuc[i]);
        userRepo.createDanhMucDefault(danhmucdefault);
      }

      SignUpController.instance.createUserFireStore(user);
    }
  }

  //Gui lai Link xac thuc email
  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendVerify = false); // để ẩn nút resend
      await Future.delayed(const Duration(seconds: 10));
      setState(() => canResendVerify = true);
    } catch (e) {
      // Get.snackbar("Error", "Khong the gui!", colorText: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const DashboardScreen()
      : SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: tDefaultSize + 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const FormHeaderWidget(
                        image: tOTPImage,
                        title: tEmailVerifyTitle,
                        subtitle: tEmailVerifySubTitle,
                        iHeight: 0.5,
                        iWidth: 1),
                    const SizedBox(height: tDefaultSize),
                    //Email
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.outgoing_mail),
                        onPressed:
                            canResendVerify ? sendVerificationEmail : null,
                        label: Text(tResendSendEmail,
                            style: Theme.of(context).textTheme.titleLarge),
                      ),
                    ),
                    const SizedBox(height: tDefaultSize),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () => FirebaseAuth.instance.signOut(),
                            // {
                            // EmailVerifiyController.instance.verifyEmail(otp);
                            // final user = UserModel(
                            //     fullName: "1",
                            //     phoneNo: controller.phoneNo.text.trim(),
                            //     password: controller.password.text.trim());

                            // SignUpController.instance.createUser(user);
                            // Get.to(() => const EmailVerifyScreen());

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           const ConfirmPassScreen()),
                            // );
                            // },
                            child: Text(tBack.toUpperCase(),
                                style: const TextStyle(fontSize: 20))))
                  ],
                ),
              ),
            ),
          ),
        );
}
