import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/common_widgets/form/form_header_widget.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/image_strings.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/auth/signin/signin.dart';

import '../../../../../../common_widgets/fontSize/font_size.dart';

class CheckResetPass extends StatelessWidget {
  const CheckResetPass({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const FormHeaderWidget(
              image: tResetPassImage,
              title: tResetPassTitle,
              subtitle: tResetPassSubTitle,
              iHeight: 0.31,
              iWidth: 7),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const SigninScreen());
                    },
                    child: Text(tBack.toUpperCase(),
                        style: TextStyle(fontSize: Font.sizes(context)[3])))),
          )
        ],
      ),
    );
  }
}
