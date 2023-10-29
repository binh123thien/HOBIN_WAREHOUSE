import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/common_widgets/fontSize/font_size.dart';
import 'package:hobin_warehouse/src/constants/sizes.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/auth/forget_password/forget_password_mail/forget_password_mail.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/auth/forget_password/forget_password_options/forget_password_btn_widget.dart';

class ForgetPasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            tMakeSelection,
            style: TextStyle(fontSize: Font.sizes(context)[2]),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            tsubMakeSelection,
            style: TextStyle(fontSize: Font.sizes(context)[1]),
          ),
          const SizedBox(height: 40.0),
          ForgetPasswordBtnWidget(
            btnIcon: Icons.mail_outline_rounded,
            title: "E-mail",
            subTittle: "Xác thực qua e-mail đã đăng ký",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ForgetPassEmailScreen()),
              );
            },
          ),
          const SizedBox(height: 30.0),
          ForgetPasswordBtnWidget(
            btnIcon: Icons.mobile_friendly_outlined,
            title: "Số điện thoại",
            subTittle: "Xác thực qua SĐT đã đăng ký",
            onTap: () {
              null;
              // Navigator.pop(context);
              // Get.to(() => const ForgetPassPhoneScreen());

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const ForgetPassEmailScreen()),
              // );
            },
          ),
        ]),
      ),
    );
  }
}
