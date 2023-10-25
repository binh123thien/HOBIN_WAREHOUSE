import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/common_widgets/form/form_header_widget.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/image_strings.dart';
import 'package:hobin_warehouse/src/constants/sizes.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/auth/forget_password/widget/forget_password_form_widget.dart';

class ForgetPassEmailScreen extends StatelessWidget {
  const ForgetPassEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FormHeaderWidget(
              image: tForgetPassImage,
              title: tForgetPassTitle,
              subtitle: tForgetPassSubTitle,
              iHeight: 0.31,
              iWidth: 0.7,
            ),
            SizedBox(height: tFormHeight),
            ForgetPassFormWidget(
              tLabel: tEmail,
              tHint: tEmail,
              tPrefixIcon: Icon(Icons.mail_outline),
            ),
          ],
        ),
      ),
    );
  }
}
