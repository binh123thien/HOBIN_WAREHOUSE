import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/form/form_header_widget.dart';
import 'package:hobin_warehouse/src/constants/image_strings.dart';
import 'package:hobin_warehouse/src/constants/sizes.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/auth/signin/signin.dart';

class CheckResetPass extends StatelessWidget {
  const CheckResetPass({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: tDefaultSize + 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const FormHeaderWidget(
                    image: tResetPassImage,
                    title: tResetPassTitle,
                    subtitle: tResetPassSubTitle,
                    iHeight: 0.5,
                    iWidth: 1),
                const SizedBox(height: tDefaultSize),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => const SigninScreen());
                        },
                        child: Text(tBack.toUpperCase(),
                            style: const TextStyle(fontSize: 20))))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
