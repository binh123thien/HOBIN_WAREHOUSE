import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/common_widgets/form/form_header_widget.dart';
import 'package:hobin_warehouse/src/constants/image_strings.dart';
import 'package:hobin_warehouse/src/constants/sizes.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/auth/forget_password/widget/forget_password_form_widget.dart';

class ForgetPassEmailScreen extends StatelessWidget {
  const ForgetPassEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: tDefaultSize + 10),
            child: const Column(
              children: [
                FormHeaderWidget(
                  image: tForgetPassImage,
                  title: tForgetPassTitle,
                  subtitle: tForgetPassSubTitle,
                  iHeight: 0.5,
                  iWidth: 1,
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
        ),
      ),
    );
  }
}
