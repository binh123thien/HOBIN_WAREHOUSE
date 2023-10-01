import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/auth/verify_email/email_verify_screen.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:hobin_warehouse/src/features/dashboard/models/danhmuc_model.dart';
import 'package:hobin_warehouse/src/features/dashboard/models/location_model.dart';
import 'package:hobin_warehouse/src/repository/exceptions/signup_email_password_failure.dart';
import 'package:hobin_warehouse/src/repository/user_repository/user_repository.dart';

import '../../features/authentication/models/user_models.dart';
import '../../features/dashboard/models/donvi_model.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //biến khởi tạo
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    // Future.delayed(const Duration(seconds: 6));
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
    // ever(listener, (callback) => null)
  }

// lắng nghe dữ liệu user đăng nhập dòng 19
  _setInitialScreen(User? user) {
    user == null
        ? Future.delayed(const Duration(seconds: 2)).then((value) {
            Get.offAll(() => const WelcomeScreen());
          })
        : Future.delayed(const Duration(seconds: 2)).then((value) {
            Get.offAll(() => const EmailVerifyScreen());
          });
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmaiAndPasswordFailure.code(e.code);
      // ignore: unnecessary_string_interpolations
      Get.snackbar("Lỗi", "${ex.message}",
          colorText: Colors.red, snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> signinWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Lỗi!', 'Tài khoản không tồn tại', colorText: Colors.red);
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Lỗi!', 'Tài khoản hoặc mật khẩu không đúng',
            colorText: Colors.red);
      }
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      // print("$e");
      if (e.code == 'user-not-found') {
        Get.snackbar('Lỗi!', 'Tài khoản không tồn tại', colorText: Colors.red);
      }
    }
  }

  signinWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn()
        .signIn(); //cho phép user đăng nhập bằng tk GG của họ

    GoogleSignInAuthentication? googleAuth = await googleUser
        ?.authentication; // cho phép ứng dụng của bạn truy cập vào các dịch vụ Google liên quan đến người dùng đã đăng nhập.

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // print(userCredential.user?.displayName);
    // print(userCredential.user);
    //Nếu user đăng nhập lần đầu => tạo user bên firestore
    //toán tử ?? false là để đảm bảo rằng giá trị mặc định của biểu thức kiểm tra là false nếu additionalUserInfo không tồn tại.
    //toán tử 3 ngôi =))
    if (userCredential.additionalUserInfo?.isNewUser ?? false) {
      final userRepo = Get.put(UserRepository());
      String? email = userCredential.user?.email;
      String? phone = userCredential.user?.phoneNumber;
      String? displayName = userCredential.user?.displayName;
      String? photoURL = userCredential.user?.photoURL;
      // print(email);
      // print(phone);
      // print(displayName);
      // print(userCredential);
      final user = UserModel(
          email: email.toString(),
          name: displayName.toString(),
          phone:
              phone.toString().toLowerCase() == "null" ? "" : phone.toString(),
          // không cho phone = String "null"
          photoURL: photoURL.toString(),
          password: "");
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

      final List<String> allLocaion = [
        "A1-01",
        "A2-01",
        "A3-01",
        "A4-01",
      ];
      for (var i = 0; i < allLocaion.length; i++) {
        final locationdefault = LocationModel(id: allLocaion[i]);
        userRepo.createLocationDefault(locationdefault);
      }
      //tạo user
      await userRepo.createUserFireStore(user);
    }
  }

  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  // Future<void> phoneAuthentication(String phoneNo) async {
  //   await _auth.verifyPhoneNumber(
  //     phoneNumber: phoneNo,
  //     verificationCompleted: (credetials) async {
  //       await _auth.signInWithCredential(credetials);
  //     },
  //     codeSent: (verificationId, resendToken) {
  //       this.verificationId.value = verificationId;
  //     },
  //     codeAutoRetrievalTimeout: (verificationId) {
  //       this.verificationId.value = verificationId;
  //     },
  //     verificationFailed: (e) {
  //       if (e.code == "invalid-phone-number") {
  //         Get.snackbar('Error!', 'Ma khong hop le');
  //       } else {
  //         Get.snackbar('Error!', 'Co loi xay ra');
  //       }
  //     },
  //   );
  // }
  //   Future<bool> verifyOTP(String otp) async {
  //   var credentials = await _auth.signInWithCredential(
  //       PhoneAuthProvider.credential(
  //           verificationId: verificationId.value, smsCode: otp));
  //   return credentials.user != null ? true : false;
  // }
}
