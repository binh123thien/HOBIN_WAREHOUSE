import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/common_widgets/form/form_header_widget.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/image_strings.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/auth/signin/widget/signin_footer_widget.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/auth/signin/widget/signin_form_widget.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => SigninScreenState();
}

class SigninScreenState extends State<SigninScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: size.width,
              height: size.height * 0.4,
              child: const Center(
                child: FormHeaderWidget(
                  image: tSignInScreenImage,
                  title: tSignupTitle,
                  subtitle: tSignupSubTitle,
                  iHeight: 0.31,
                  iWidth: 7,
                ),
              ),
            ),
            SizedBox(
                width: size.width,
                height: size.height * 0.6,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      SignInForm(),
                      SigninFooterWidget(),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
