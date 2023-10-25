import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/image_strings.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/auth/signup/widgets/signup_footer_widget.dart';

import '../../../../../common_widgets/form/form_header_widget.dart';
import 'widgets/signup_form_widget.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
              child: const FormHeaderWidget(
                image: tSignUpScreenImage,
                title: tSignupTitle,
                subtitle: tSignupSubTitle,
                iHeight: 0.31,
                iWidth: 0.7,
              ),
            ),
            SizedBox(
                width: size.width,
                height: size.height * 0.65,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      SignUpFormWidget(),
                      SignUpFooterWidget(),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
