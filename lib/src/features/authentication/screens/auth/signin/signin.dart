import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/common_widgets/form/form_header_widget.dart';
import 'package:hobin_warehouse/src/constants/image_strings.dart';
import 'package:hobin_warehouse/src/constants/sizes.dart';
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
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: const Column(
              children: [
                FormHeaderWidget(
                  image: tSignInScreenImage,
                  title: tSignupTitle,
                  subtitle: tSignupSubTitle,
                  iHeight: 0.2,
                  iWidth: 0.6,
                ),
                SignInForm(),
                SigninFooterWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
